class AddEnumSourceToSensorReading < ActiveRecord::Migration
  def change
    add_column :sensor_readings, :source, :integer, default: 0
  end
end
