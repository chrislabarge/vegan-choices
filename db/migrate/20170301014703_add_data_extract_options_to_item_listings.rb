class AddDataExtractOptionsToItemListings < ActiveRecord::Migration[5.0]
  def change
    add_column :item_listings, :data_extract_options, :hstore, default: {}, null: false
  end
end
