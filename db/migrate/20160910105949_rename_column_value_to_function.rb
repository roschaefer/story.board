class RenameColumnValueToFunction < ActiveRecord::Migration
  def change
    rename_column :commands, :value, :function
  end
end
