class CreateActors < ActiveRecord::Migration
  def change
    create_table :actors do |t|
      t.string :name
      t.integer :port
      t.string :function

      t.timestamps null: false
    end
  end
end
