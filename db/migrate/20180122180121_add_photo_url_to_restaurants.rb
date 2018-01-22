class AddPhotoUrlToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :photo_url, :string
  end
end
