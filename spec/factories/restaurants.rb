FactoryGirl.define do
  factory :restaurant do
    name Faker::Company.name
    website Faker::Internet.url
  end
end
