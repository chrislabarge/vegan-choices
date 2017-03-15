class RenameNameToFilenameInItemListings < ActiveRecord::Migration[5.0]
  def change
    rename_column :item_listings, :name, :filename
  end
end
