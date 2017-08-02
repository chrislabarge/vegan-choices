class RenameAllergensToAllregenStringForItems < ActiveRecord::Migration[5.0]
  def change
    rename_column :items, :allergens, :allergen_string
  end
end
