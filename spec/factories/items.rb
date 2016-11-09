FactoryGirl.define do
  factory :item do
    sequence(:name) { |n| "item#{n}" }
    restaurant nil
    item_type nil
    certified_vegan false
    img_path nil # get rid of this attribute
  end
end
