class AddMoreColumnsToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :phone_number, :string
    add_column :locations, :street_number, :string
    add_column :locations, :hours, :jsonb
  end
end
