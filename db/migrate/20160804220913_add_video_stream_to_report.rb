class AddVideoStreamToReport < ActiveRecord::Migration
  def change
    add_column :reports, :video, :string
  end
end
