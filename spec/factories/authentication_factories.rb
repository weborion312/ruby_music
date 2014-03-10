FactoryGirl.define do
  factory :authentication do
    sequence(:uid) { |n| n }
    association :user, nil
  end
end
