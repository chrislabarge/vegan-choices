FactoryGirl.define do
  factory :item_type do
    sequence(:name) { |n| "item_type#{n}" }
  end
end
