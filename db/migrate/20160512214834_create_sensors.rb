class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.string :name
      t.integer :address
      t.string :type
      t.string :unit

      t.timestamps null: false
    end
  end
end
