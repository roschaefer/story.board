class AddReportIdToSensors < ActiveRecord::Migration
  def change
    add_reference :sensors, :report, index: true
  end
end
