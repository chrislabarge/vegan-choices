class CreateRecipeItems < ActiveRecord::Migration[5.0]
  def change
    create_table :recipe_items do |t|
      t.references :recipe, foreign_key: true
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
