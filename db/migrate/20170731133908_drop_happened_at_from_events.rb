class DropHappenedAtFromEvents < ActiveRecord::Migration[5.0]
  def change
    Event.find_each do |event|
      old_happened_at = event.read_attribute(:happened_at)
      event.start(old_happened_at) if old_happened_at
    end
    remove_column :events, :happened_at, :datetime
  end
end
