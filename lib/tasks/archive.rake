namespace :archive do
  desc "Archive current report"
  task :real => :environment do
    report = Report.current
    Report.current.archive!(DiaryEntry.new(report: report, intention: :real))
  end

  desc "Archive current preview"
  task :fake => :environment do
    report = Report.current
    Report.current.archive!(DiaryEntry.new(report: report, intention: :fake))
  end
end

desc "Archive reports"
task :archive => ['archive:real', 'archive:fake']
