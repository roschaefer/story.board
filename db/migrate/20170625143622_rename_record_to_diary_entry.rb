class RenameRecordToDiaryEntry < ActiveRecord::Migration[5.0]
  def change
    rename_table :records, :diary_entries
  end
end
