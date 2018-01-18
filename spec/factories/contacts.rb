FactoryBot.define do
  factory :contact do
    name Faker::Name.name
    email Faker::Internet.email
    message Faker::Hipster.paragraph
  end
end
