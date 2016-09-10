class CreateChains < ActiveRecord::Migration
  def change
    create_table :chains do |t|
      t.references :actuator, index: true, foreign_key: true
      t.integer :function
      t.string :hashtag

      t.timestamps null: false
    end
  end
end
