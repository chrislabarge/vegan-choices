class CreateFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true
      t.references :restaurant, foreign_key: true
      t.references :item, foreign_key: true
      t.references :profile
      t.foreign_key :users, column: :profile_id

      t.timestamps
    end
  end
end
