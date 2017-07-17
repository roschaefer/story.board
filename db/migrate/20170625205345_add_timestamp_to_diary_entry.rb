class AddTimestampToDiaryEntry < ActiveRecord::Migration[5.0]
  def change
    add_column :diary_entries, :moment, :timestamp
    DiaryEntry.update_all("moment=created_at")
  end
end
