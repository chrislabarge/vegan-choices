FactoryBot.define do
  factory :location do
    # state_model
    country { Faker::Address.country }
    state { Faker::Address.state }
    city  { Faker::Address.city }
    latitude  { Faker::Address.latitude }
    longitude  { Faker::Address.longitude }
    restaurant nil
    user nil
  end
end
