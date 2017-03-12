class CreatePublishingContexts < ActiveRecord::Migration[5.0]
  def change
    create_table :publishing_contexts do |t|
      t.string :name
      t.timestamps
    end

    add_column :text_components, :publishing_context_id, :integer
  end
end
