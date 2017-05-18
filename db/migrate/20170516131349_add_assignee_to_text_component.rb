class AddAssigneeToTextComponent < ActiveRecord::Migration[5.0]
  def change
    add_reference :text_components, :assignee, index: true, references: :users, foreign_key: {to_table: :users}
  end
end
