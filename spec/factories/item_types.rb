FactoryGirl.define do
  factory :item_type do
    name { [ItemType::Beverage].sample }
  end
end
