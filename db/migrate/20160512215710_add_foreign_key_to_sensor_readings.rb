class AddForeignKeyToSensorReadings < ActiveRecord::Migration
  def change
		add_reference :sensor_readings, :sensor, index: true
  end
end
