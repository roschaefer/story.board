class CreateTextComponentsTriggers < ActiveRecord::Migration
  def change
    create_table :text_components_triggers do |t|
      t.belongs_to :text_component, index: true
      t.belongs_to :trigger,        index: true
    end
  end
end
