class ContentBerry < ApplicationRecord
  include NotificationResource

  belongs_to :user, inverse_of: :content_berries
  belongs_to :restaurant, inverse_of: :content_berries
  belongs_to :item, inverse_of: :content_berries
  belongs_to :comment, inverse_of: :content_berries

  after_create :notifiy_content_creator
  after_destroy :remove_notifications

  scope :restaurants, -> { joins(:restaurant) }
  scope :items, -> { joins(:item) }
  scope :comments, -> { joins(:restaurant) }

  def for_user
    send(self.type).user
  end

  def type
    [:restaurant, :item, :comment].each do |type|
      return type if send(type)
    end
  end

  private
  # TODO: I HAVE TO PREVENT FROM PEOPLE clicking the berry button too many times
  # I dont want there to be a notification for every time someone double
  # clicks on the berry button
  def notifiy_content_creator
    return unless (user = send(self.type).try(:user))

    notify_user(user)
  end
end
