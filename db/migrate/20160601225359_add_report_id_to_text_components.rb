class AddReportIdToTextComponents < ActiveRecord::Migration
  def change
    add_reference :text_components, :report, index: true
  end
end
