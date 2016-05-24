class CreateSensorTypes < ActiveRecord::Migration
  def change
    create_table :sensor_types do |t|
      t.string :property
      t.string :unit

      t.timestamps null: false
    end
  end
end
