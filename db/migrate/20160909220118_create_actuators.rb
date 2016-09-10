class CreateActuators < ActiveRecord::Migration
  def change
    create_table :actuators do |t|
      t.string :name
      t.integer :port
      t.string :function

      t.timestamps null: false
    end
  end
end
