namespace :opjam do
  desc 'Generate 128 new users'
  task :generate_users => :environment do

    (1..128).each do |u|
      user                        = User.create(
           :email                 => "user#{u}@example.com",
           :password              => 'password',
           :password_confirmation => 'password',
           :username              => "tester_#{u}",
           )
      user.save(:validate=>false)
      puts "User #{user.id} created!\n"
    end
  end

  desc 'destroy all users'
  task :destroy_users => :environment do
    User.all.each do |user|
      id = user.id
      user.destroy
      puts "User #{id} destroyed!\n"
    end
  end
end
