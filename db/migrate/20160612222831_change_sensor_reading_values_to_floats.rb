class ChangeSensorReadingValuesToFloats < ActiveRecord::Migration
  def change
    change_column :sensor_readings, :calibrated_value, :float
    change_column :sensor_readings, :uncalibrated_value, :float
  end
end
