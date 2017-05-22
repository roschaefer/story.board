class AddPublicationStatusToTextComponents < ActiveRecord::Migration[5.0]
  def change
    add_column :text_components, :publication_status, :integer, :default => 0
  end
end
