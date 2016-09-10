class ActuatorRemoveColumnFunction < ActiveRecord::Migration
  def change
    remove_column :actuators, :function
  end
end
