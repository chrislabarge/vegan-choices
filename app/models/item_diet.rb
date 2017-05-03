class ItemDiet  < ApplicationRecord
  belongs_to :item, inverse_of: :item_diets
  belongs_to :diet, inverse_of: :item_diets

  after_commit :process_recipe_diets

  def process_recipe_diets
    item = self.item

    return unless (recipe_items = item.recipe_items).present?
    recipes = recipe_items.map(&:recipe)
    recipes.each do |r|

      item_with_recipe = r.item
      item_with_recipe.send(:process_item_diets)
    end
  end
end
