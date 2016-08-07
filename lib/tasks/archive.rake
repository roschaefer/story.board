namespace :archive do
  desc "Archive current report"
  task :real do
    Report.current.archive!(:real)
  end

  desc "Archive current preview"
  task :fake do
    Report.current.archive!(:fake)
  end
end

desc "Archive reports"
task :archive => ['archive:real', 'archive:fake']
