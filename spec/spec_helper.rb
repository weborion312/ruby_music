require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  add_group 'Models', '/app/models/'
  add_group 'Controllers', '/app/controllers/'
  add_group 'Helpers', '/app/helpers/'
end

require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require 'rails/application'
  Spork.trap_method Rails::Application, :reload_routes!
  Spork.trap_method Rails::Application::RoutesReloader, :reload!

  require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
  require 'rspec/rails'
  require 'factory_girl'
  require 'capybara/rails'
  require 'capybara/dsl'
  require 'shoulda-matchers'
  require 'capybara/poltergeist'
  require 'selenium-webdriver'
  require 'selenium/webdriver/remote/http/curb'

  Capybara.default_wait_time = 5

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app,js_errors: true, inspector: true, debug: 'chrome')
  end

  `#{Selenium::WebDriver::Firefox::Binary.path} -CreateProfile WebDriver > /dev/null 2>&1`
  Capybara.register_driver :firefox do |app|
    Capybara::Selenium::Driver.new app,
    :browser => :firefox,
    :profile => 'WebDriver',
    :http_client => Selenium::WebDriver::Remote::Http::Curb.new
  end

  # Capybara.javascript_driver = :poltergeist
  Capybara.javascript_driver = :webkit
  # Capybara.javascript_driver = :firefox
  # Capybara.javascript_driver = :chrome
  Capybara.current_driver = :webkit

  RSpec.configure do |config|
    # Show complete backtrace
    if ENV['VERBOSE'] == 'true'
      config.backtrace_clean_patterns = []
    end

    config.mock_with :rspec

    config.include FactoryGirl::Syntax::Methods

    # If you're not using ActiveRecord you should remove these
    # lines, delete config/database.yml and disable :active_record
    # in your config/boot.rb
    config.use_transactional_fixtures = true

    config.include ActionController::RecordIdentifier, :type => :request

    # For assert_difference
    config.include ActiveSupport::Testing::Assertions

    # Devise helpers
    config.include Devise::TestHelpers, :type => :controller
    # config.include Devise::SpecHelpers, :type => :controller

    # Capybara inclusion for integration tests
    config.include Capybara, :type => :integration

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
      Warden.test_reset!
    end
  end
end

Spork.each_run do
  Dir[Rails.root.join("app/controllers/**/*.rb")].each {|f| require f}
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
end

unless FactoryGirl.factories.count > 0
  Dir.glob("#{Rails.root}/spec/factories/*.rb").each { |file| require file }
end
