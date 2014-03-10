require 'carrierwave/processing/mime_types'
require 'carrierwave/ffmpeg'

class OGAUploader < CarrierWave::Uploader::Base

  include CarrierWave::FFMPEG
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  include CarrierWave::MimeTypes

  storage :file

  process :set_content_type

  version :high do
    process :transcode => [:oga, :high]
  end

  version :low do
    process :transcode => [:oga, :low]
  end

  def filename
    @name ||= "#{to_oga_ext(@original_filename)}" if original_filename
  end

  def store_dir
    "system/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  private

  def to_oga_ext original_name
    original_name.gsub(/\.[\d\w]{3}$/,'.oga')
  end
end
