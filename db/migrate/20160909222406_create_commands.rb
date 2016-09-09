class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.references :actor, index: true, foreign_key: true
      t.string :value
      t.boolean :executed

      t.timestamps null: false
    end
  end
end
