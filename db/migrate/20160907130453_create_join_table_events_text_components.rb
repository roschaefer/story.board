class CreateJoinTableEventsTextComponents < ActiveRecord::Migration
  def change
    create_table :events_text_components, id: false do |t|
      t.belongs_to :event, index: true
      t.belongs_to :text_component, index: true
    end
  end
end
