class CreateAllergens < ActiveRecord::Migration[5.0]
  def change
    create_table :allergens do |t|
      t.string :name

      t.timestamps
    end
  end
end
