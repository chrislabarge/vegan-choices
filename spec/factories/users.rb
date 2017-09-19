FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    email Faker::Internet.email
    password 'password'
    password_confirmation 'password'
    uid nil
    provider nil
  end
end