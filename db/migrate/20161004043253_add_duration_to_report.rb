class AddDurationToReport < ActiveRecord::Migration
  def change
    add_column :reports, :duration, :integer
  end
end
