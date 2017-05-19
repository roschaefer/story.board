class RemoveUniquceConstraintOnVariables < ActiveRecord::Migration[5.0]
  def change
    remove_index :variables, :key
    add_index :variables, :key, unique: false
  end
end
