class AddUniqueConstraintToActorName < ActiveRecord::Migration
  def change
    add_index :actors, :name, unique: true
  end
end
