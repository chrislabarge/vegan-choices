FactoryGirl.define do
  factory :item_listing do
    path nil
    filename nil
    # sequence(:filename) { |n| "item_listing#{n}.pdf" }
    url nil
    restaurant
  end
end
