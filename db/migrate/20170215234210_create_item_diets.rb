class CreateItemDiets < ActiveRecord::Migration[5.0]
  def change
    create_table :item_diets do |t|
      t.references :item, foreign_key: true
      t.references :diet, foreign_key: true

      t.timestamps
    end
  end
end
