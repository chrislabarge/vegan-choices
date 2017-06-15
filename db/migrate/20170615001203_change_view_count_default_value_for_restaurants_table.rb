class ChangeViewCountDefaultValueForRestaurantsTable < ActiveRecord::Migration[5.0]
  def change
    change_column :restaurants, :view_count, :integer, :default => 0
  end
end
