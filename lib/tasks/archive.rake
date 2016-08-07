namespace :archive do
  desc "Archive current report"
  task :real => :environment do
    Report.current.archive!(:real)
  end

  desc "Archive current preview"
  task :fake => :environment do
    Report.current.archive!(:fake)
  end
end

desc "Archive reports"
task :archive => ['archive:real', 'archive:fake']
