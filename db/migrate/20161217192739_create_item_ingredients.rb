class CreateItemIngredients < ActiveRecord::Migration[5.0]
  def change
    create_table :item_ingredients do |t|
      t.references :item, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.integer :parent_id
      t.string :description
      t.string :context

      t.timestamps
    end
  end
end
