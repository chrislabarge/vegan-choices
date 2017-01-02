FactoryGirl.define do
  factory :item do
    sequence(:name) { |n| "item#{n}" }
    restaurant
    item_type
    certified_vegan false

    after(:build) { |item| item.define_singleton_method(:no_image_file_notification) {} }
  end
end
