class Ingredient < ApplicationRecord
  has_many :item_ingredients, inverse_of: :ingredient
  has_many :items, through: :item_ingredients

  validates :name, presence: true, uniqueness: true
end
