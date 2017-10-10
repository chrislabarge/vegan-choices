class CreateRestaurantComments < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurant_comments do |t|
      t.references :comment, foreign_key: true
      t.references :restaurant, foreign_key: true

      t.timestamps
    end
  end
end
