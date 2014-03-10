require 'carrierwave/processing/mime_types'
require 'carrierwave/ffmpeg'

class MP3Uploader < CarrierWave::Uploader::Base

  include CarrierWave::FFMPEG
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  include CarrierWave::MimeTypes

  storage :file

  process :set_content_type

  version :high do
    process :transcode => [:mp3, :high]
  end

  version :low do
    process :transcode => [:mp3, :low]
  end

  def filename
    @name ||= "#{to_mp3_ext(@original_filename)}" if original_filename
  end

  def store_dir
    "system/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  private

  def to_mp3_ext original_name
    original_name.gsub(/\.[\d\w]{3}$/,'.mp3')
  end
end
