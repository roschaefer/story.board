class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.datetime :start_date

      t.timestamps null: false
    end
  end
end
