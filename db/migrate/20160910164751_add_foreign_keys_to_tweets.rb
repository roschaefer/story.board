class AddForeignKeysToTweets < ActiveRecord::Migration
  def change
    add_reference :tweets, :chain, index: true, foreign_key: true
    add_reference :tweets, :command, index: true, foreign_key: true
  end
end
