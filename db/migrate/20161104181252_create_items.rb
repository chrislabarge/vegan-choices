class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name
      t.references :restaurant, foreign_key: true
      t.references :item_type, foreign_key: true
      t.boolean :certified_vegan
      t.string :ingredients

      t.timestamps
    end
  end
end
