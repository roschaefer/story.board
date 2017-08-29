# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, './log/cron.log'

%w[6:05 9:05 13:05 18:05 23:05 3:05].each do |time|
  every :day, at: time do
    rake 'archive'
  end
end

every 15.minutes do
  rake 'smaxtec_api:update_sensors'
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
