class ChangeItemColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :items, :ingredients, :ingredient_string
  end
end
