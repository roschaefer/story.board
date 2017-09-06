class AddDataCollectionMethodToSensorTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :sensor_types, :data_collection_method, :integer, default: 0
  end
end
