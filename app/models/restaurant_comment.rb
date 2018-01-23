class RestaurantComment < ApplicationRecord
  include NotificationResource

  belongs_to :comment, inverse_of: :restaurant_comment
  belongs_to :restaurant, inverse_of: :restaurant_comments

  has_one :user, through: :comment

  accepts_nested_attributes_for :comment

  after_create :notify_content_creator
  after_destroy :remove_notifications

  delegate :content, to: :comment, prefix: false

  def notify_content_creator
    return unless (creator = restaurant.try(:user))
    return unless (user != creator)

    notify_user(creator)
  end
end
