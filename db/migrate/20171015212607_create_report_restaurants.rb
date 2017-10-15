class CreateReportRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :report_restaurants do |t|
      t.references :restaurant, foreign_key: true
      t.references :report, foreign_key: true
      t.references :report_reason, foreign_key: true
      t.text :custom_reason

      t.timestamps
    end
  end
end
