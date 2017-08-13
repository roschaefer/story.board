class AddImageToTextComponents < ActiveRecord::Migration[5.0]
  def up
    add_attachment :text_components, :image
  end

  def down
    remove_attachment :text_components, :image
  end
end
