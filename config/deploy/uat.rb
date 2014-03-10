set :rails_env, 'uat'

server 'web-01.uat.opjam.com', :web, :app, :db, :resque_worker, :primary => true

set :branch, 'develop'
