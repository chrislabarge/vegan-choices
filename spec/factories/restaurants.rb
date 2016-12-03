FactoryGirl.define do
  factory :restaurant do
    sequence(:name) { |n| "Restaurant item#{n}" }
    website Faker::Internet.url

    [:create_image_dir,
     :update_image_dir,
     :no_image_file_notification].each do |method|
      after(:build) { |restaurant| restaurant.define_singleton_method(method) {} }
    end
  end
end
