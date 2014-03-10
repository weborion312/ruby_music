namespace :opjam do
  desc "Create all tracks media MP3s and OGAs uploads"
  task :create_audio_uploads => :environment do
    Track.all.each do |t|
      t.mp3.store!(File.open(t.media.path)) if t.mp3.blank?
      t.oga.store!(File.open(t.media.path)) if t.oga.blank?
      t.save!
    end
  end

  desc "Recreate all tracks media MP3s and OGAs uploads"
  task :recreate_audio_uploads => :environment do
    Track.all.each do |t|
      puts "Recreating #{t.name} uploads"
      t.media.recreate_versions! unless t.media.blank?
      t.mp3.recreate_versions! unless t.mp3.blank?
      t.oga.recreate_versions! unless t.oga.blank?
    end
  end

  desc "Create Tracks tokens"
  task :create_tracks_tokens => :environment do
    Track.all.each do |t|
      t.update_attributes!(:token => ::SecureRandom.urlsafe_base64(8)) unless t.token
    end
  end

  desc "Re-create Users avatar versions"
  task :recreate_users_avatar_versions => :environment do
    User.all.each do |u|
      u.avatar.recreate_versions! unless u.avatar.blank?
    end
  end

  desc "Re-create Tracks artwork versions"
  task :recreate_tracks_artwork_versions => :environment do
    Track.all.each do |t|
      t.artwork.recreate_versions! unless t.artwork.blank?
    end
  end
end
