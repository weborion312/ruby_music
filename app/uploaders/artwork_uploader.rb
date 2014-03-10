class ArtworkUploader < CarrierWave::Uploader::Base

  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  include CarrierWave::RMagick

  storage :file

  [16, 32, 64, 128, 256].each do |s|
    version "img#{s}".to_sym do
      process :resize_to_fill => [s,s]
    end
  end

  def store_dir
    "system/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
