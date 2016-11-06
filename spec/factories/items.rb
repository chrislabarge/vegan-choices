FactoryGirl.define do
  factory :item do
    sequence(:name) { |n| "item#{n}" }
    restaurant nil
    item_type nil
    certified_vegan false
    img_path Faker::File.file_name('/app/assets/images/items/', nil, 'jpeg')
  end
end
