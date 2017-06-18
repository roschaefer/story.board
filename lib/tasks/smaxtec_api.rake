namespace :smaxtec_api do
  desc "get temperature"
  task :get_temperature => :environment do
    smaxtec_api_controller = SmaxtecApi.new
    puts smaxtec_api_controller.get_temperature
  end

  desc "update sensor readings"
  task :update_sensor_readings => :environment do
    smaxtec_api_controller = SmaxtecApi.new
    smaxtec_api_controller.update_sensor_readings
  end
end
