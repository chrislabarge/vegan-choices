class CreateIngredientLists < ActiveRecord::Migration[5.0]
  def change
    create_table :ingredient_lists do |t|
      t.string :path
      t.string :name
      t.references :restaurant, foreign_key: true

      t.timestamps
    end
  end
end
