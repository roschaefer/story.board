class AddIntentionToRecords < ActiveRecord::Migration
  def change
    add_column :records, :intention, :integer, default: 0
  end
end
