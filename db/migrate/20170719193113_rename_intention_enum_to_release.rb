class RenameIntentionEnumToRelease < ActiveRecord::Migration[5.0]
  def change
    rename_column :diary_entries, :intention, :release
    rename_column :sensor_readings, :intention, :release
  end
end
