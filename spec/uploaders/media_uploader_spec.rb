require 'carrierwave/test/matchers'

describe MediaUploader do
  include CarrierWave::Test::Matchers

  let(:user) { User.make! }

  before do
    MediaUploader.enable_processing = true
    @uploader = MediaUploader.new(user, :avatar)
    @uploader.store!(File.open('spec/support/empty.mp3'))
  end

  after do
    MediaUploader.enable_processing = false
    @uploader.remove!
  end

  it "should make the image readable only to the owner and not executable" do
    @uploader.should have_permissions(0644)
  end
end
