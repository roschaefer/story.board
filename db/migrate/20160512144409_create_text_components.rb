class CreateTextComponents < ActiveRecord::Migration
  def change
    create_table :text_components do |t|
      t.string :heading
      t.text :introduction
      t.text :main_part
      t.text :closing

      t.timestamps null: false
    end
  end
end
