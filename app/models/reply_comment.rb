class ReplyComment < ApplicationRecord
  belongs_to :reply_to, class_name: 'Comment', foreign_key: :reply_to_id, dependent: :destroy
  belongs_to :comment, dependent: :destroy

  validates :comment, presence: true
  validates :reply_to, presence: true

  accepts_nested_attributes_for :comment
end
