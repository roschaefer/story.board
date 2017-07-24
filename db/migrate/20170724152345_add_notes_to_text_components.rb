class AddNotesToTextComponents < ActiveRecord::Migration[5.0]
  def change
    add_column :text_components, :notes, :text
  end
end
