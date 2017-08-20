class AddUniqueConstraintToDeviceId < ActiveRecord::Migration[5.0]
  def change
    add_index :sensors, [:device_id], :unique => true
  end
end
