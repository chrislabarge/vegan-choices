class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.string :resource
      t.integer :resource_id
      t.string :title
      t.text :message
      t.boolean :received

      t.timestamps
    end
  end
end
