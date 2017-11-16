class CreateItemComments < ActiveRecord::Migration[5.0]
  def change
    create_table :item_comments do |t|
      t.references :item, foreign_key: true
      t.references :comment, foreign_key: true

      t.timestamps
    end
  end
end
