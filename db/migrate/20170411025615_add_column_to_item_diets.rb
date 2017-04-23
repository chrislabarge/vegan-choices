class AddColumnToItemDiets < ActiveRecord::Migration[5.0]
  def change
    add_column :item_diets, :certified, :boolean
  end
end
