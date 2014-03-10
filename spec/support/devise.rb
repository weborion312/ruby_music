RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller

  require Rails.root + 'spec/support/test_helpers'
  config.include Opjam::TestHelpers, :type => :request
end
