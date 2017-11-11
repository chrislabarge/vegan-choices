FactoryGirl.define do
  factory :user do
    name { Faker::Internet.user_name(nil, ['_']) }
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    uid nil
    provider nil
  end
end
