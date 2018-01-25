class AddVeganMenuColumnsToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :vegan_menu, :boolean
    add_column :restaurants, :menu_url, :string
  end
end
