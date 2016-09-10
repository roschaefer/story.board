class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :user
      t.text :message
      t.datetime :tweeted_at

      t.timestamps null: false
    end
  end
end
