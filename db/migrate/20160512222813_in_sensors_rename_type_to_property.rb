class InSensorsRenameTypeToProperty < ActiveRecord::Migration
  def change
    change_table :sensors do |t|
      t.rename :type, :property
    end
  end
end
