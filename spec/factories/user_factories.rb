FactoryGirl.define do
  sequence(:random_string) {|n|  }

  factory :terms_and_conditions do
    sequence(:notes) {|n| "#{Faker::Lorem.words(2).join(' ')}:#{n}" }
    sequence(:content) { |n| "#{Faker::Lorem.words(50).join(' ')}:#{n}" }
    active false

    factory :terms_and_conditions_current do
      active true
    end
  end

  factory :user do
    sequence(:username) {|n| "user#{n}"}
    sequence(:email) {|n| "useremail#{n}@test.com"}
    password 'password'
    password_confirmation 'password'
    age_accepted true
    terms_and_conditions_accepted '1'
    terms_and_conditions FactoryGirl.create(:terms_and_conditions_current)

    factory :admin do
      sequence(:username) {|n| "admin#{n}"}
      sequence(:email) {|n| "adminemail#{n}@example.com"}
    end
  end
end
