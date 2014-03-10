require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'airbrake/capistrano'
require 'capistrano-resque'


set :stages, %w(production staging uat)
set :default_stage, 'uat'

set :application, 'webjam'
set :deploy_to, "/srv/www/#{application}"

set :scm, :git
set :repository, 'git@github.com:Opjam/webjam.git'

set :user, 'deploy'
set :use_sudo, false

set :deploy_via, :remote_cache

set :ssh_options, {
  :forward_agent => true,
  :port => 22,
  # :verbose => :debug,
  :paranoid => false
}

set :keep_releases, 3
after 'deploy:update', 'deploy:cleanup'

set :default_shell, "/bin/bash --login"

set :shared_children, shared_children + %w(sockets)

set(:unicorn_pid) { "#{shared_path}/pids/unicorn.pid" }

set :workers, { '*' => 4 }
after 'deploy:restart', 'resque:restart'


namespace :db do
  task :check_migrations do
    run "cd #{deploy_to}/current && bundle exec rake db:warn_if_pending_migrations RAILS_ENV=#{rails_env}"
  end
end
after 'deploy', 'db:check_migrations'

namespace :unicorn do
  desc "start unicorn"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle exec unicorn_rails -c #{current_path}/config/unicorn.rb -E #{rails_env} -D"
  end

  desc "stop unicorn"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "kill `cat #{unicorn_pid}`"
  end

  desc "graceful stop unicorn"
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end

  desc "restart unicorn"
  task :restart, :roles => :app do
    stop
    start
  end

  desc "reload unicorn"
  task :reload, :roles => :app, :except => { :no_release => true } do
    begin
      run "kill -s HUP `cat #{unicorn_pid}`"
    rescue
      start
    end
  end

  after "deploy:restart", "unicorn:restart"

  # Why is this not just in config/unicorn.rb?
  desc "Create unicorn config"
  task :config do
    require 'erb'
    config = ERB.new <<-EOF
      worker_processes 4

      working_directory "#{current_path}" # available in 0.94.0+

      listen "#{shared_path}/sockets/unicorn.sock", :backlog => 64
      pid "#{shared_path}/pids/unicorn.pid"
      stderr_path "#{shared_path}/log/unicorn.stderr.log"
      stdout_path "#{shared_path}/log/unicorn.stdout.log"

      preload_app true

      before_fork do |server, worker|
        defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
      end

      after_fork do |server, worker|
        defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
      end
    EOF

    put config.result, "#{current_path}/config/unicorn.rb"
  end
  before "deploy:restart", "unicorn:config"

end

namespace :deploy do
 namespace :assets do
   task :precompile, :roles => :web, :except => { :no_release => true } do
     run_locally("rm -rf public/assets/*")
     run_locally("bundle exec rake assets:precompile")
     servers = find_servers_for_task(current_task)
     servers.each do |server|
       run_locally("rsync --recursive \
                      --times \
                      --rsh=ssh \
                      --compress \
                      --progress public/assets #{user}@#{server}:#{shared_path}")
     end
     run_locally("rm -rf public/assets/*")
   end
 end
end


namespace :deploy do
  desc <<-DESC
    Migrate the database from one environment to another.

    Uses xtrabackup to dump the database, tar it up, stream it to
    the database server in another environment.

    Accepts one option:

      - `from`: Which environment to pull the database from.
                If you don't specify `from`, it will default to "production".

    Examples:

    # migrate the production database to staging
    cap staging deploy:migrate_db

    # migrate the staging database to uat
    cap uat deploy:migrate_db from="staging"

  DESC
  task :migrate_db, :roles => :db do
    set :user, ENV['USER']
    # Option parsing.
    from_environment = ENV['FROM'] || ENV['from'] || 'production'
    to_environment   = fetch(:stage).to_s
    puts "Pulling from the #{from_environment} environment."

    if !fetch(:stages).include?(from_environment) then
      puts "Capistrano doesn't know about the #{from_environment} environment."
      puts 'Exiting!'
      exit 2
    end

    if to_environment == from_environment
      puts 'What are you doing? You can\'t pull from the same environment.'
      puts 'Exiting!'
      exit 2
    end

    if to_environment == 'production' && ENV['really_really_sure'] != 'true' then
      puts 'Are you realy really sure? You are about to blow away the production database!!!!'
      puts 'Run this command again with really_really_sure=true'
      puts 'Exiting!'
      exit 2
    end

    to = find_servers(:roles => :db).first
    puts "Destination DB: #{to}"

    find_and_execute_task(from_environment)
    from   = ((find_servers(:roles => :db) - [to]).find { |s| s.host =~ /#{from_environment.gsub('staging', 'stage').gsub('production', 'prod')}/ })

    from = from.host
    to   = to.host
    puts "Source DB: #{from}"

    # Stop MySQL on the to machine
    run "#{sudo} service mysql stop || #{sudo} killall mysqld_safe mysqld || true", :hosts => to

    # Do the backup, tar it over the wire
    run 'mkdir -p ~/backups', :once => true, :hosts => from
    run "#{sudo} innobackupex --user=root --defaults-file=/etc/mysql/my.cnf --parallel=5 ~/backups", :once => true, :hosts => from

    path = capture('find ~/backups -mindepth 1 -maxdepth 1 -type d |sort  |tail -n 1', :once => true, :hosts => from).strip
    # TODO Why does this fail
    run "#{sudo} innobackupex --apply-log --parallel=4 #{path} || true", options

    run "cd #{path} && #{sudo} tar cf #{path}/../mysql.tar .", :hosts => from
    run "cd #{path} && scp #{path}/../mysql.tar #{to}:/tmp", :hosts => from

    run "#{sudo} rm -rf /var/lib/mysql/*", :hosts => to
    run "#{sudo} tar --extract --verbose --directory /var/lib/mysql --file /tmp/mysql.tar", :hosts => to
    run "#{sudo} chown mysql:mysql -R /var/lib/mysql", :hosts => to

    # Bring MySQL back up.
    run "#{sudo} service mysql start", :hosts => to
  end

  desc <<-DESC
    Migrate the assetts from one environment to another.

    Accepts one option:

      - `from`: Which environment to pull the database from.
                If you don't specify `from`, it will default to "production".

    Examples:

    # migrate the production assets to staging
    cap staging deploy:migrate_assets

    # migrate the assets from staging to uat
    cap uat deploy:migrate_assets from="staging"

  DESC
  task :migrate_assets, :roles => :db do
    set :user, ENV['USER']
    # Option parsing.
    from_environment = ENV['FROM'] || ENV['from'] || 'production'
    to_environment   = fetch(:stage).to_s
    puts "Pulling from the #{from_environment} environment."

    if !fetch(:stages).include?(from_environment) then
      puts "Capistrano doesn't know about the #{from_environment} environment."
      puts 'Exiting!'
      exit 2
    end

    if to_environment == from_environment
      puts 'What are you doing? You can\'t pull from the same environment.'
      puts 'Exiting!'
      exit 2
    end

    if to_environment == 'production' && ENV['really_really_sure'] != 'true' then
      puts 'Are you realy really sure? You are about to blow away the production database!!!!'
      puts 'Run this command again with really_really_sure=true'
      puts 'Exiting!'
      exit 2
    end

    to = find_servers(:roles => :web).first
    puts "Destination Web: #{to}"

    find_and_execute_task(from_environment)
    from   = ((find_servers(:roles => :web) - [to]).find { |s| s.host =~ /#{from_environment.gsub('staging', 'stage').gsub('production', 'prod')}/ })

    from = from.host
    to   = to.host
    puts "Source Web: #{from}"

    run "#{sudo} rm -rf /tmp/shared", :hosts => to
    run "cd /srv/www/webjam/shared && scp -r /srv/www/webjam/shared/system #{to}:/tmp", :hosts => from
    run "#{sudo} rm -rf /srv/www/webjam/shared/system", :hosts => to
    run "#{sudo} mv /tmp/system /srv/www/webjam/shared/system", :hosts => to
    run "#{sudo} chown -R deploy.deploy /srv/www/webjam/shared/system", :hosts => to
  end
end

namespace :opjam do
  desc "Run rake tasks agains the given ENV. `cap opjam:rake -s opjam_task='notes'`"
  task :rake, :roles => :app, :except => { :no_release => true } do
    run("cd #{deploy_to}/current && /usr/bin/env rake #{opjam_task} RAILS_ENV=#{fetch(:stage).to_s}")
  end
end
