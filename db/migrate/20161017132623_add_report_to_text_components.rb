class AddReportToTextComponents < ActiveRecord::Migration
  def change
    add_reference :text_components, :report, index: true, foreign_key: true
  end
end
