# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, './log/cron.log'
#
 every 4.hours do
   rake "archive"
 end

 every 15.minutes do
   rake "smaxtec_api:update_sensor_readings"
 end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
