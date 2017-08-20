class AddImageAltToTextComponents < ActiveRecord::Migration[5.0]
  def change
    add_column :text_components, :image_alt, :text
  end
end
