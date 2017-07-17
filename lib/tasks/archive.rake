namespace :archive do
  desc "Archive current report"
  task :real => :environment do
    Report.find_each do |report|
      DiaryEntry.new(report: report, intention: :real).archive!
    end
  end

  desc "Archive current preview"
  task :fake => :environment do
    Report.find_each do |report|
      DiaryEntry.new(report: report, intention: :fake).archive!
    end
  end
end

desc "Archive reports"
task :archive => ['archive:real', 'archive:fake']
