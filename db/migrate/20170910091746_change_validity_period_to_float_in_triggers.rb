class ChangeValidityPeriodToFloatInTriggers < ActiveRecord::Migration[5.0]
  def change
    change_column :triggers, :validity_period, :float
  end
end
