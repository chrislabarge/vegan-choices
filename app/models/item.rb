# Item
class Item < ApplicationRecord
  require 'csv'
  belongs_to :restaurant, inverse_of: :items
  belongs_to :item_type, inverse_of: :items

  validates :name, presence: true

  def ingredient_list
    return ingredients.scan(/(?:\([^()]*\)|[^,])+/).map(&:strip)
    nil
  end
end
