class UntieChannelAndReport < ActiveRecord::Migration[5.0]
  def change
    remove_column :channels, :report_id, :integer
  end
end
