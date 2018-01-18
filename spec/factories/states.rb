FactoryBot.define do
  factory :state do
    name { Faker::Address.state }
    abreviation  { Faker::Address.state_abbr }
  end
end
