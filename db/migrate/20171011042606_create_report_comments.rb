class CreateReportComments < ActiveRecord::Migration[5.0]
  def change
    create_table :report_comments do |t|
      t.string :custom_reason
      t.references :comment, foreign_key: true
      t.references :report_reason, foreign_key: true
      t.references :report, foreign_key: true

      t.timestamps
    end
  end
end
