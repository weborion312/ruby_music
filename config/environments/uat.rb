require_relative 'production'

# customise settings which are different from production
Opjam::Application.configure do
  config.action_mailer.default_url_options[:host] = 'uat.opjam.com'
  config.middleware.delete Rack::Rewrite
end
