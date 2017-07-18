class DropGeneratedColumnsFromDiaryEntries < ActiveRecord::Migration[5.0]
  def change
    remove_column :diary_entries, :heading, :string
    remove_column :diary_entries, :introduction, :string
    remove_column :diary_entries, :main_part, :string
    remove_column :diary_entries, :closing, :string
  end
end
