class AddSmaxtecSensorToSensors < ActiveRecord::Migration[5.0]
  def change
    add_column :sensors, :smaxtec_sensor, :bool
  end
end
