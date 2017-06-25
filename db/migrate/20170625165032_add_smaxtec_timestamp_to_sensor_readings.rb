class AddSmaxtecTimestampToSensorReadings < ActiveRecord::Migration[5.0]
  def change
    add_column :sensor_readings, :smaxtec_timestamp, :timestamp
  end
end
