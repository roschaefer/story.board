class CommandsChangeColumnValueToEnum < ActiveRecord::Migration
  def change
    remove_column :commands, :value
    add_column :commands, :value, :integer
  end
end
