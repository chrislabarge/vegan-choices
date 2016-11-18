FactoryGirl.define do
  factory :ingredient do
    sequence(:name) { |n| "ingredient#{n}" }
    # restaurant nil
    # item_type nil
    # certified_vegan false

    # after(:build) { |item| item.define_singleton_method(:no_image_file_notification) {} }
  end
end
