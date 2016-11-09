FactoryGirl.define do
  factory :item do
    sequence(:name) { |n| "item#{n}" }
    restaurant nil
    item_type nil
    certified_vegan false
  end
end
