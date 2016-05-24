class AddSensorTypeIdToSensor < ActiveRecord::Migration
  def change
    add_reference :sensors, :sensor_type, index: true
  end
end
