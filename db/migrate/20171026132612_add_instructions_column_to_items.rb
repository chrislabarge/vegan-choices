class AddInstructionsColumnToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :instructions, :text
  end
end
