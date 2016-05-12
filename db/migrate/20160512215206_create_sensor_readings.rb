class CreateSensorReadings < ActiveRecord::Migration
  def change
    create_table :sensor_readings do |t|
      t.integer :calibrated_value
      t.integer :uncalibrated_value

      t.timestamps null: false
    end
  end
end
