class CreateItemPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :item_photos do |t|
      t.references :item, foreign_key: true
      t.references :user, foreign_key: true
      t.string :photo

      t.timestamps
    end
  end
end
