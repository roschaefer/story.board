class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.integer :from
      t.integer :to
      t.references :text_component, index: true, foreign_key: true
      t.references :sensor, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
