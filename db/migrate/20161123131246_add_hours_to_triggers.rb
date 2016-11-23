class AddHoursToTriggers < ActiveRecord::Migration[5.0]
  def change
    add_column :triggers, :from_hour, :integer
    add_column :triggers, :to_hour, :integer
  end
end
