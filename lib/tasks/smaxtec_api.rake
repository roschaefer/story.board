namespace :smaxtec_api do
  desc "update sensor readings"
  task update_sensor_readings: :environment do
    smaxtec_api_controller = SmaxtecApi.new
    smaxtec_api_controller.update_sensor_readings
  end

  desc "add smaxtec sensortypes"
  task add_smaxtec_sensortypes: :environment do
    SensorType.find_or_create_by(property: 'pH Value', unit: 'pH')
    SensorType.find_or_create_by(property: 'Movement', unit: '1-100')
  end
end
