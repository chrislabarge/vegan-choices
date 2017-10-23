class Favorite < ApplicationRecord
  belongs_to :user, inverse_of: :favorites
  belongs_to :restaurant, inverse_of: :favorites
  belongs_to :item, inverse_of: :favorites

  scope :restaurants, -> { joins(:restaurant) }
  scope :items, -> { joins(:item) }

  validates :user_id, presence: true
  validates :restaurant_id, uniqueness: { allow_blank: true, scope: :user_id } if :restaurant
  validates :item_id, uniqueness: { allow_blank: true, scope: :user_id } if :item

  def type
    return :restaurant if restaurant
    return :item if item
  end
end
