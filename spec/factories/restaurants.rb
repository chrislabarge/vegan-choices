FactoryBot.define do
  factory :restaurant do
    sequence(:name) { |n| "Restaurant#{n}" }
    website Faker::Internet.url
    view_count 0
    location

    %w(create_image_dir update_image_dir no_image_file_notification).each do |attr|
      after(:build) { |restaurant| restaurant.define_singleton_method(attr) {} }
    end
  end
end
