FactoryGirl.define do
  factory :broadcast do
    user
    image File.open("spec/support/cover_001.jpg")
    sequence(:description) { |n| "#{Faker::Lorem.words(10).join(' ')}:#{n}" }
    sequence(:title) { |n| "#{Faker::Lorem.words(2).join(' ')}:#{n}" }
  end
end
