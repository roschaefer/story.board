class AddUniqueConstraintToActorName < ActiveRecord::Migration
  def change
    add_index :actuators, :name, unique: true
  end
end
