class ItemComment < ApplicationRecord
  include NotificationResource

  belongs_to :item, inverse_of: :item_comments
  belongs_to :comment, inverse_of: :item_comment

  has_one :user, through: :comment
  delegate :content, to: :comment, prefix: false

  validates :item, presence: true
  validates :comment, presence: true

  accepts_nested_attributes_for :comment

  after_create :notify_content_creator
  after_create :notify_item_favoritors
  after_destroy :remove_notifications

  delegate :content, to: :comment, prefix: false

  def notify_content_creator
    notify_creator(:item)
  end

  def notify_item_favoritors
    creator_id = item.try(:user).try(:id)
    item_id = item.try(:id)
    users = User.where.not(id: creator_id).joins(:favorite_items).where('favorites.item_id = ?', item_id)

    return unless users.present?

    notify_users(users, :item_comment)
  end
end
