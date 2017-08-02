class Allergen < ApplicationRecord
  has_many :item_allergens, inverse_of: :allergen
  has_many :items, through: :item_allergens
end
