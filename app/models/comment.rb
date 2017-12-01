class Comment < ApplicationRecord
  include DefaultBerry

  belongs_to :user, inverse_of: :comments

  has_many :reply_comments, foreign_key: :reply_to_id, dependent: :destroy
  has_many :content_berries, inverse_of: :comment, dependent: :destroy
  has_many :comments, through: :reply_comments, source: :comment, dependent: :destroy

  has_one :item_comment, inverse_of: :comment, dependent: :destroy
  has_one :restaurant_comment, inverse_of: :comment, dependent: :destroy
  has_one :reply_comment, dependent: :destroy
  has_one :report_comment, dependent: :destroy
  has_one :item, through: :item_comment
  has_one :restaurant, through: :restaurant_comment

  validates :user_id, presence: true

  after_create :give_default_berry

  scope :report_comments, -> { joins(:report_comment) }

  def self.types
    [:item, :restaurant, :reply_comment]
  end

  def type
    Comment.types.each do |type|
      return type if send type
    end

    nil
  end

  def preview
    content[0..30]
  end
end
