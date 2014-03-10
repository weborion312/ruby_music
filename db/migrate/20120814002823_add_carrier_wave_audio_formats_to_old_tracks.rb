class AddCarrierWaveAudioFormatsToOldTracks < ActiveRecord::Migration
  def self.up
    Track.all.each do |t|
      t.mp3.store!(File.open(t.media.path))
      t.oga.store!(File.open(t.media.path))
      t.save!
    end
  end
end
