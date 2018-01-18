FactoryBot.define do
  factory :location do
    state
    city  { Faker::Address.city }
  end
end
