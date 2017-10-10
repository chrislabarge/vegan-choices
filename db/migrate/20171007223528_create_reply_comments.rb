class CreateReplyComments < ActiveRecord::Migration[5.0]
  def change
    create_table :reply_comments do |t|
      t.references :comment
      t.references :reply_to
      t.foreign_key :comments, column: :reply_to_id
      t.timestamps
    end
  end
end
