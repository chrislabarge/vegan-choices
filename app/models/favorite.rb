class Favorite < ApplicationRecord
  belongs_to :user, inverse_of: :favorites
  belongs_to :restaurant, inverse_of: :favorites

  scope :restaurants, -> { joins(:restaurant) }

  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: :restaurant_id } if :restaurant
end
