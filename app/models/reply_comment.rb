class ReplyComment < ApplicationRecord
  include NotificationResource

  belongs_to :reply_to, class_name: 'Comment', foreign_key: :reply_to_id, dependent: :destroy
  belongs_to :comment, dependent: :destroy

  has_one :user, through: :comment

  validates :comment, presence: true
  validates :reply_to, presence: true

  accepts_nested_attributes_for :comment

  after_save :notify_content_creator
  after_destroy :remove_notifications

  delegate :content, to: :comment, prefix: false

  def notify_content_creator
    return unless (user = reply_to.try(:user))

    notify_user(user)
  end
end
