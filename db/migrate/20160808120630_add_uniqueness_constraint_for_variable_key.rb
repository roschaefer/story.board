class AddUniquenessConstraintForVariableKey < ActiveRecord::Migration
  def change
    add_index :variables, :key, unique: true
  end
end
