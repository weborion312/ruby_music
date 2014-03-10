require 'webjam/ffmpeg'

module CarrierWave
  module FFMPEG
    module ClassMethods

      def transcode format, quality
        process :transcode => [format, quality]
      end
    end

    def transcode format, quality
      WebJam::FFMPEG.new(current_path, format, quality).transcode!
    end
  end
end
