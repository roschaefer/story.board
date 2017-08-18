class CreateEventActivations < ActiveRecord::Migration[5.0]
  def change
    create_table :event_activations do |t|
      t.timestamp :started_at
      t.timestamp :ended_at
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
