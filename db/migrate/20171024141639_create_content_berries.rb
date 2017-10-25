class CreateContentBerries < ActiveRecord::Migration[5.0]
  def change
    create_table :content_berries do |t|
      t.references :user, foreign_key: true
      t.references :restaurant, foreign_key: true
      t.references :item, foreign_key: true
      t.references :comment, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
