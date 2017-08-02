class CreateItemAllergens < ActiveRecord::Migration[5.0]
  def change
    create_table :item_allergens do |t|
      t.references :allergen, foreign_key: true
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
