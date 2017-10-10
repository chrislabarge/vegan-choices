class ItemComment < ApplicationRecord
  belongs_to :item, inverse_of: :item_comments
  belongs_to :comment, inverse_of: :item_comment

  has_one :user, through: :comment
  delegate :content, to: :comment, prefix: false

  validates :item, presence: true
  validates :comment, presence: true

  accepts_nested_attributes_for :comment
end
