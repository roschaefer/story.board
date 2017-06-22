namespace :smaxtec_api do
  desc "get temperature"
  task :last_smaxtec_sensor_reading => :environment do
    smaxtec_api_controller = SmaxtecApi.new
    puts smaxtec_api_controller.last_smaxtec_sensor_reading
  end

  desc "update sensor readings"
  task :update_sensor_readings => :environment do
    smaxtec_api_controller = SmaxtecApi.new
    smaxtec_api_controller.update_sensor_readings
  end
end
