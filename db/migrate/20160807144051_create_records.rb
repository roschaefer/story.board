class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :heading
      t.string :introduction
      t.string :main_part
      t.string :closing
      t.references :report, index: true

      t.timestamps null: false
    end
  end
end
