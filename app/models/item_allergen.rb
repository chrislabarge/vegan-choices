class ItemAllergen < ApplicationRecord
  belongs_to :allergen, inverse_of: :item_allergens
  belongs_to :item, inverse_of: :item_allergens
end
