class AddViewsColumnToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :view_count, :integer
  end
end
