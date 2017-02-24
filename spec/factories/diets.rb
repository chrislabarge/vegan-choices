FactoryGirl.define do
  factory :diet do
    sequence(:name) { |n| "Diet#{n}" }
  end
end
