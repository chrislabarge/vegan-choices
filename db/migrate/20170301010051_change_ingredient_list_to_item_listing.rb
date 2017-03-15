class ChangeIngredientListToItemListing < ActiveRecord::Migration[5.0]
  def change
    rename_table :ingredient_lists, :item_listings
  end
end
