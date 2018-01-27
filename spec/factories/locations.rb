FactoryBot.define do
  factory :location do
    country { Faker::Address.country }
    state { Faker::Address.state }
    city  { Faker::Address.city }
    latitude  { Faker::Address.latitude.to_f.round(4) }
    longitude  { Faker::Address.longitude.to_f.round(4) }
    restaurant nil
    user nil
  end
end
