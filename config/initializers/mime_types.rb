Mime::Type.register 'audio/mpeg', :mp3
Mime::Type.register 'audio/ogg; codecs="vorbis"', :oga
Mime::Type.register 'audio/ogg', :ogg

Rack::Mime::MIME_TYPES.merge!({
  ".ogg"     => "application/ogg",
  ".ogx"     => "application/ogg",
  ".ogv"     => "video/ogg",
  ".oga"     => '"audio/ogg; codecs="vorbis"',
  ".mp4"     => "video/mp4",
  ".m4v"     => "video/mp4",
  ".mp3"     => "audio/mpeg",
  ".m4a"     => "audio/mpeg",
  ".htc"     => "text/x-component"
})
