class AddUniqueConstraintToAnimalId < ActiveRecord::Migration[5.0]
  def change
    add_index :sensors, [:sensor_type_id, :animal_id], :unique => true
  end
end
