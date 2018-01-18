FactoryBot.define do
  factory :reply_comment do
    comment
    reply_to { FactoryBot.create(:comment) }
  end
end
