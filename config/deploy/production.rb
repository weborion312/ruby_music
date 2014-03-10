set :rails_env, 'production'

server 'web-01.prod.opjam.com', :web, :app, :db, :resque_worker, :primary => true

set :branch, 'master'
