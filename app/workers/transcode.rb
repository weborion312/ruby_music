class Transcode
  @queue = :transcode_queue
  def self.perform(track_id)
    track = Track.find(track_id)
    track.mp3.store!(File.open(track.media.path))
    track.oga.store!(File.open(track.media.path))
    track.save!
  end
end
