class AddSensorTypeToDeviceIdUniqueConstraint < ActiveRecord::Migration[5.0]
  def change
    remove_index :sensors, :device_id
    add_index :sensors, [:sensor_type_id, :device_id], :unique => true
  end
end
