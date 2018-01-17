class AddLocationReferenceToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_reference :restaurants, :location, foreign_key: true
  end
end
