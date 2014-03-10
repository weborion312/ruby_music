source 'https://rubygems.org'

gem 'rails', '3.2.6'
gem 'mysql2'

group :assets do
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
  gem 'bourbon'
end

# authentication
gem 'devise' #, :git => 'git://github.com/plataformatec/devise.git'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-myspace'

# views
gem 'kaminari'
gem 'representative_view'
gem 'haml'
gem 'jquery-rails'
gem 'carrierwave'
gem 'rmagick'
gem 'friendly_id', '~> 4.0.1'
gem 'acts_as_list'

# forms
gem 'simple_form', '~> 2.0.0'

# CMS
# Include refinery bits manually so we don't get its auth
gem 'refinerycms-core'
gem 'refinerycms-dashboard'
gem 'refinerycms-images'
gem 'refinerycms-resources'
gem 'refinerycms-pages'
gem 'refinerycms-news'
gem 'refinerycms-inquiries'

# parsing
gem 'ruby_parser'
gem 'hpricot'

# javascript integration
gem 'rails-backbone'
gem 'handlebars-rails', :git => 'git://github.com/willrjmarshall/handlebars-rails.git'
gem 'eco'

# We use machinist to generate content as well
# gem 'machinist'
# gem 'nokogiri'

# Deploy with Capistrano
gem 'capistrano' #, :git => 'https://github.com/capistrano/capistrano.git'
gem 'capistrano_colors'
gem 'capistrano-resque'

# moved this out of assets for active_admin
gem 'sass-rails', '~> 3.2.3'
gem 'gravtastic'
gem 'analytical'
gem 'rack-rewrite'
gem 'airbrake'

# Misc
gem 'quiet_assets'
gem 'cocaine', '>= 0.0.2'

# Serving
gem 'unicorn'

# moved out due to ENVs assets compilation conflicts
gem 'jasminerice'

gem 'resque', :require => 'resque/server'
gem 'paper_trail'

# admin
gem 'activeadmin', '0.4.4' # :git => 'git://github.com/gregbell/active_admin.git'
gem 'tinymce-rails'

group :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'poltergeist'
  gem 'capybara-webkit', :git => 'git://github.com/thoughtbot/capybara-webkit.git'
  gem 'database_cleaner'
  gem 'fuubar'
  gem 'spork-rails'
  gem 'curb'
  gem 'ffaker'
end

group :test, :development do
  gem 'factory_girl'
  gem 'awesome_print'
  gem 'pry-rails'
  gem 'simplecov'
  gem 'thin'
#  gem 'rails-footnotes', :git => 'https://github.com/josevalim/rails-footnotes.git'
  gem 'guard-jasmine'
end

group :development do
  gem 'ir_b'
end
