class AddCalibrationAttributesToSensor < ActiveRecord::Migration[5.0]
  def change
    add_column :sensors, :calibrating, :boolean
    add_column :sensors, :max_value, :float
    add_column :sensors, :min_value, :float
    add_column :sensors, :calibrated_at, :datetime
  end
end
