module WebJam
  class Mp3Metadata

    attr_reader :mp3, :metadata

    def initialize file
      @mp3      = file
      @metadata = process_mp3
    end

    def duration
      Float(metadata['duration'].strip).round.to_i
    end

    def artist
      mp3.artist ||= metadata['tag:artist'] ||
        metadata['tag:tp1'] ||
        metadata['tag:tpe1']
    end

    def tags
      mp3.tags ||= metadata['tag:genre'] ||
        metadata['tag:tco'] ||
        metadata['tag:tcon']
    end

    def name
      mp3.name = metadata['tag:title'] ||
        metadata['tag:tt2'] ||
        metadata['tag:tit2'] ||
        File.basename(mp3.media.path, File.extname(mp3.media.path))
    end

    private

    def process_mp3
      cmdline = "ffprobe \
                   -show_streams \
                   -show_format #{Shellwords.escape mp3.media.path} 2> /dev/null"
      output = `#{cmdline}`
      raise "Error running #{cmdline.inspect}, returned #{$?}" unless $?.success?
      data = {}
      output.lines.each do |line|
        line.chomp!
        next if line =~ /\A\[.+\]\z/
        line =~ /\A([^=]+)=(.*)\z/ or raise "Error parsing: #{line.inspect}"
        data[$1.downcase] = $2.strip
      end
      data
    end
  end
end
