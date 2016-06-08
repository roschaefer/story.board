class AddPriorityToTextComponents < ActiveRecord::Migration
  def change
    add_column :text_components, :priority, :integer
  end
end
