set :rails_env, 'staging'

server 'web-01.stage.opjam.com', :web, :app, :db, :resque_worker, :primary => true

set :branch, 'master'
