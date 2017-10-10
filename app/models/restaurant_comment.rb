class RestaurantComment < ApplicationRecord
  belongs_to :comment, inverse_of: :restaurant_comment
  belongs_to :restaurant, inverse_of: :restaurant_comments

  has_one :user, through: :comment

  accepts_nested_attributes_for :comment
end
