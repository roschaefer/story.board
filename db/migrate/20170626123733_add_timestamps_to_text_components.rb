class AddTimestampsToTextComponents < ActiveRecord::Migration[5.0]
  def change
    add_column :text_components, :created_at, :timestamp
    add_column :text_components, :updated_at, :timestamp
  end
end
