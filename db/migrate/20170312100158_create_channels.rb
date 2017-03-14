class CreateChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :channels do |t|
      t.string :name
      t.text :description
      t.belongs_to :report

      t.timestamps
    end
  end
end
