FactoryGirl.define do
  factory :item do
    sequence(:name) { |n| "item#{n}" }
    restaurant
    item_type nil
    certified_vegan false
    ingredient_string 'some ingredient, another ingredient'
    allergens 'CONTAINS: allergen'

    after(:build) { |item| item.define_singleton_method(:no_image_file_notification) {} }
  end
end
