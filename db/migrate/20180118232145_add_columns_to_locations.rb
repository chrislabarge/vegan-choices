class AddColumnsToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :country, :string
    add_column :locations, :state, :string
    add_column :locations, :street, :string
    add_reference :locations, :restaurant, foreign_key: true
    add_reference :locations, :user, foreign_key: true
  end
end
