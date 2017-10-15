FactoryGirl.define do
  factory :report_restaurant do
    restaurant
    report
    report_reason
    custom_reason "MyText"
  end
end
