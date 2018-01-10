FactoryGirl.define do
  factory :user do
    name { Faker::Internet.user_name(3..25, ['_']) }
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    uid nil
    provider nil
  end
end
