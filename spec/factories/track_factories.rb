FactoryGirl.define do
  factory :track do |t|
    t.user { |t| t.association :user }
    name "blah"
    media File.open("spec/support/empty.mp3")
    private false
    pulled false
  end
end
