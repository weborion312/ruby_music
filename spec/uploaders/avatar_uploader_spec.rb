require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  let(:user) { User.make! }

  before do
    AvatarUploader.enable_processing = true
    @uploader = AvatarUploader.new(user, :avatar)
    @uploader.store!(File.open('spec/support/cover_001.jpg'))
  end

  after do
    AvatarUploader.enable_processing = false
    @uploader.remove!
  end

  it "should make the image readable only to the owner and not executable" do
    @uploader.should have_permissions(0644)
  end
end
