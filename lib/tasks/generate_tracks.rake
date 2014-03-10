namespace :opjam do
  desc 'Generate 128 new tracks with random data, empty.mp3 and images'
  task :generate_tracks => :environment do

    2.times do
      track = Track.create!(
        :user    => User.first,
        :artwork => File.open(Rails.root + 'public/images/boilerplate/cover_001.jpg'),
        :name    => 'Default Track 1',
        :media    => File.open(Rails.root + "spec/support/empty.mp3"),
        :private => false,
        :pulled => false
      )

      puts "Track #{Track.last.id} created!\n"

      (2..64).each do |i|
        track = Track.create!(
                      :user  => User.first,
                      :name => "Default Track #{i}",
                      :artwork => File.open(Rails.root + "public/images/boilerplate/cover_#{i.to_s.rjust(3, "0")}.jpg"),
                      :media => File.open(Rails.root + "spec/support/empty.mp3"),
                      :private => false,
                      :pulled => false
                      )

        puts "Track #{Track.last.id} created!\n"
      end
    end
  end

  desc 'destroy all tracks'
  task :destroy_tracks => :environment do
    Track.all.each do |track|
      id = track.id
      track.destroy
      puts "Track #{id} destroyed!\n"
    end
  end
end
