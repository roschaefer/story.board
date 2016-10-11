class RenameTextComponentsToTriggers < ActiveRecord::Migration
  def change
    rename_table :text_components, :triggers
    rename_table :events_text_components, :events_triggers
    rename_column :conditions, :text_component_id, :trigger_id
    rename_column :events_triggers, :text_component_id, :trigger_id
  end
end
