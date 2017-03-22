class CreateJoinTableForTextComponentsAndTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :text_components_topics do |t|
      t.belongs_to :text_component, index: true
      t.belongs_to :topic,          index: true
    end
    remove_column :text_components, :topic_id, :integer
  end
end
