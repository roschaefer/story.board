class MoveHoursFromTriggerToTextComponent < ActiveRecord::Migration[5.0]
  def change
    remove_column :triggers, :from_hour, :integer
    remove_column :triggers, :to_hour, :integer
    add_column :text_components, :from_hour, :integer
    add_column :text_components, :to_hour, :integer
  end
end
