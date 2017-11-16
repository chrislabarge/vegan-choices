class CreateReportReasons < ActiveRecord::Migration[5.0]
  def change
    create_table :report_reasons do |t|
      t.string :name

      t.timestamps
    end
  end
end
