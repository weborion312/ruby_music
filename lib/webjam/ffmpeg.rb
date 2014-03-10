require 'webjam'

module WebJam
  class FFMPEG

    def initialize file, format, quality
      @file    = File.open(file)
      @format  = format
      @quality = quality
      @tmpfile = Tempfile.new([@file.path, ".#{format}"])
      @tmpfile.binmode
    end

    def transcode!
      if @format == :mp3
        process(to_mp3_args)
      else
        process(to_oga_args)
      end
    end

    private

    def to_oga_args
      args = ["-y -i :source"]
      args << "-f ogg -acodec libvorbis"
      args << "-ac 2 -ab :bit_rate -ar 44100"
      args << ":dest"
      args.join(" ")
    end

    def to_mp3_args
      args = ["-y -i :source"]
      args << "-acodec libmp3lame"
      args << "-ac 2 -ab :bit_rate -ar 44100"
      args << ":dest"
      args.join(" ")
    end

    def bit_rate
      @quality == :high ? '192K' : '96K'
    end

    def process args
      begin
        WebJam::Spawn::run(
                       "ffmpeg",
                       args,
                       {:source => @file.path,
                             :swallow_stderr => true,
                             :bit_rate => bit_rate,
                             :dest => @tmpfile.path})
      rescue Cocaine::CommandNotFoundError => e
        raise WebJam::Error, "ffmpg not found: #{e}"
      rescue Cocaine::ExitStatusError => e
        raise WebJam::Error, "error while processing audio for #{@file}: #{e}"
      end

      FileUtils.mv(@tmpfile.path, @file.path)
      @file
    end
  end
end
