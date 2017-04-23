class AddAllergensToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :allergens, :string
  end
end
