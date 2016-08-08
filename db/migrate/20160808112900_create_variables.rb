class CreateVariables < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      t.string :key
      t.string :value
      t.references :report, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
