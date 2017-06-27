class RenameTimelinessConstraintToValidityPerion < ActiveRecord::Migration[5.0]
  def change
    rename_column :triggers, :timeliness_constraint, :validity_period
  end
end
