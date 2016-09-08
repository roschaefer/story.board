namespace :archive do
  desc "Archive current report"
  task :real => :environment do
    Report.current.archive!(intention: :real)
  end

  desc "Archive current preview"
  task :fake => :environment do
    Report.current.archive!(intention: :fake)
  end
end

desc "Archive reports"
task :archive => ['archive:real', 'archive:fake']
