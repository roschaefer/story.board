class AddMainHashtagToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :main_hashtag, :string
  end
end
