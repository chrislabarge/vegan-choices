class CreateReportItems < ActiveRecord::Migration[5.0]
  def change
    create_table :report_items do |t|
      t.references :item, foreign_key: true
      t.references :report, foreign_key: true
      t.references :report_reason, foreign_key: true
      t.text :custom_reason

      t.timestamps
    end
  end
end
