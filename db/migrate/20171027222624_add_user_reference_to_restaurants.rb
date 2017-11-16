class AddUserReferenceToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_reference :restaurants, :user, foreign_key: true
  end
end
