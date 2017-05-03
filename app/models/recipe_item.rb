class RecipeItem < ApplicationRecord
  belongs_to :recipe, inverse_of: :recipe_items
  belongs_to :item, inverse_of: :recipe_items

  has_many :diets, through: :item

  validates :item_id, presence: true, uniqueness: { scope: :recipe_id }

  delegate :name, to: :item, prefix: false
end
