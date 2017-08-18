class AddDefaultForTriggerPriority < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:triggers, :priority, from: nil, to: 1)
  end
end
