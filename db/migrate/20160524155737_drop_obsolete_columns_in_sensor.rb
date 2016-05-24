class DropObsoleteColumnsInSensor < ActiveRecord::Migration
  def change
    remove_column :sensors, :unit
    remove_column :sensors, :property
  end
end
