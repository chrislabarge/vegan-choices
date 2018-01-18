FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "item#{n}" }
    restaurant
    item_type nil
    ingredient_string 'some ingredient, another ingredient'
    allergen_string 'CONTAINS: allergen'
    description Faker::Lorem.sentence(5)
    instructions Faker::Lorem.sentence(5)

    after(:build) { |item| item.define_singleton_method(:no_image_file_notification) {} }
  end
end
