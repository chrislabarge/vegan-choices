FactoryGirl.define do
  factory :diet do
    sequence(:diet) { |n| "diet#{n}" }
  end
end
