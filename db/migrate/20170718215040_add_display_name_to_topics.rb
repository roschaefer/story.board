class AddDisplayNameToTopics < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :display_name, :string
    Topic.update_all("display_name=name")
  end
end
