class Comment < ApplicationRecord
  belongs_to :user, inverse_of: :comments

  has_many :reply_comments, foreign_key: :reply_to_id, dependent: :destroy
  has_many :comments, through: :reply_comments, source: :comment, dependent: :destroy

  has_one :item_comment, inverse_of: :comment, dependent: :destroy
  has_one :restaurant_comment, inverse_of: :comment, dependent: :destroy
  has_one :reply_comment, dependent: :destroy
  has_one :report_comment, dependent: :destroy

  validates :user_id, presence: true

  scope :report_comments, -> { joins(:report_comment) }
end
