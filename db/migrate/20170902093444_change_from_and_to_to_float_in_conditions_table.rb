class ChangeFromAndToToFloatInConditionsTable < ActiveRecord::Migration[5.0]
  def change
    change_column :conditions, :from, :float
    change_column :conditions, :to, :float
  end
end
