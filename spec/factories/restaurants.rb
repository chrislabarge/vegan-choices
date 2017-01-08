FactoryGirl.define do
  factory :restaurant do
    sequence(:name) { |n| "Restaurant#{n}" }
    website Faker::Internet.url

    #make these below into one!!!
    after(:build) { |restaurant| restaurant.define_singleton_method(:create_image_dir) {} }
    after(:build) { |restaurant| restaurant.define_singleton_method(:update_image_dir) {} }
    after(:build) { |restaurant| restaurant.define_singleton_method(:no_image_file_notification) {} }
  end
end
