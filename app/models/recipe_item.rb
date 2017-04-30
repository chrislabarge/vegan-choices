class RecipeItem < ApplicationRecord
  belongs_to :recipe, inverse_of: :recipe_items
  belongs_to :item, inverse_of: :recipe_items

  validates :item_id, presence: true, uniqueness: { scope: :recipe_id }
end
