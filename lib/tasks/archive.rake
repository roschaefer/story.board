namespace :archive do
  desc "Archive current report"
  task :real => :environment do
    DiaryEntry.new(report: Report.current, intention: :real).archive!
  end

  desc "Archive current preview"
  task :fake => :environment do
    DiaryEntry.new(report: Report.current, intention: :fake).archive!
  end
end

desc "Archive reports"
task :archive => ['archive:real', 'archive:fake']
