class CommandChangeColumnExecutedToEnum < ActiveRecord::Migration
  def change
    remove_column :commands, :executed
    add_column :commands, :status, :integer, default: 0, null: false
  end
end
