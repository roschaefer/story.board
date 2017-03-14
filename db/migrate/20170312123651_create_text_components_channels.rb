class CreateTextComponentsChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :channels_text_components do |t|
      t.belongs_to :channel,        index: true
      t.belongs_to :text_component, index: true
    end
  end
end
