class AddMoreDefaultReports < ActiveRecord::Migration[5.0]
  def change
    Report.create!(name: 'Industrie', start_date: Time.now)
    Report.create!(name: 'Bio', start_date: Time.now)
    Report.create!(name: 'Konventionell', start_date: Time.now)
  end
end
