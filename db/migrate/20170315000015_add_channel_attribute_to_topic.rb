class AddChannelAttributeToTopic < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :channel, :integer
  end
end
