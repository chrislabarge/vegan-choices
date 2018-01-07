class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.references :state, foreign_key: true
      t.string :city

      t.timestamps
    end
  end
end
