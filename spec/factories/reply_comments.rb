FactoryGirl.define do
  factory :reply_comment do
    comment
    reply_to { FactoryGirl.create(:comment) }
  end
end
