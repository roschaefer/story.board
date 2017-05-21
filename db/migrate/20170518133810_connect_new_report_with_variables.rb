class ConnectNewReportWithVariables < ActiveRecord::Migration[5.0]
  def up
    default_report = Report.current
    Variable.find_each do |variable|
      Report.where.not(id: default_report.id).find_each do |report|
        Variable.create!(key: variable.key, value: variable.value, report: report)
      end
    end
  end
end
