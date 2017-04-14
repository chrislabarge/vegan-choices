class ItemDiet  < ApplicationRecord
  belongs_to :item, inverse_of: :item_diets
  belongs_to :diet, inverse_of: :item_diets
end
