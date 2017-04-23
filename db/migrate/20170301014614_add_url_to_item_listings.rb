class AddUrlToItemListings < ActiveRecord::Migration[5.0]
  def change
    add_column :item_listings, :url, :string
  end
end
