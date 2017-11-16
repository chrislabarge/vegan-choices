FactoryGirl.define do
  factory :notification do
    user
    resource nil
    resource_id 1
    title Faker::Lorem.word
    message Faker::Lorem.sentence(5)
    received false
  end
end

