class Favorite < ApplicationRecord
  belongs_to :user, inverse_of: :favorites
  belongs_to :restaurant, inverse_of: :favorites
  belongs_to :item, inverse_of: :favorites
  belongs_to :profile, :class_name => 'User', :foreign_key  => "profile_id"

  scope :restaurants, -> { joins(:restaurant) }
  scope :items, -> { joins(:item) }
  scope :profiles, -> { joins(:user) }

  validates :user_id, presence: true
  validates :restaurant_id, uniqueness: { allow_blank: true, scope: :user_id } if :restaurant
  validates :item_id, uniqueness: { allow_blank: true, scope: :user_id } if :item
  validates :profile_id, uniqueness: { allow_blank: true, scope: :user_id } if :profile

  def type
    [:restaurant, :item, :profile].each do |type|
      return type if send(type)
    end
  end
end
