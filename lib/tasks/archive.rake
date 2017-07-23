namespace :archive do
  desc "Archive current report"
  task :final => :environment do
    Report.find_each do |report|
      DiaryEntry.new(report: report, release: :final).archive!
    end
  end

  desc "Archive current preview"
  task :debug => :environment do
    Report.find_each do |report|
      DiaryEntry.new(report: report, release: :debug).archive!
    end
  end
end

desc "Archive reports"
task :archive => ['archive:final', 'archive:debug']
