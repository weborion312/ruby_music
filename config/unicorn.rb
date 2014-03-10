worker_processes 2
working_directory "/srv/www/webjam/production/current" # available in 0.94.0+

preload_app true

timeout 30

listen "/src/www/webjam/production/shared/sockets/unicorn.sock", :backlog => 64
pid "/src/www/webjam/production/shared/pids/unicorn.pid"

# Set the path of the log files inside the log folder of the testapp
stderr_path "/src/www/webjam/production/log/unicorn.stderr.log"
stdout_path "/src/www/webjam/production/log/unicorn.stdout.log"

before_fork do |server, worker|
# This option works in together with preload_app true setting
# What is does is prevent the master process from holding
# the database connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end
after_fork do |server, worker|
# Here we are establishing the connection after forking worker
# processes
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end


