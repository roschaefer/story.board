namespace :smaxtec_api do
  desc "update sensors"
  task update_sensors: :environment do
    smaxtec_api_controller = SmaxtecApi.new
    smaxtec_api_controller.update_sensor_readings
    smaxtec_api_controller.update_events
    smaxtec_api_controller.update_device_readings
  end

  desc "add smaxtec sensortypes"
  task add_smaxtec_sensortypes: :environment do
    SensorType.find_or_create_by(property: 'pH Value', unit: 'pH')
    SensorType.find_or_create_by(property: 'Movement', unit: '1-100')
    SensorType.find_or_create_by(property: 'Event: Drink Cycles', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: Drink cycle increase', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: Drink cycle decrease', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: Temperature increase', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: Calving (temperature decrease)', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: Temperature decrease', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: pH amplitude', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: > 300 minutes under pH 5.8', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: pH daily mean increase', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: pH daily mean decrease', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: pH half daily mean increase', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: pH half daily mean decrease', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: Activity increase (unknown cause)', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: Heat (activity increase)', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: Activity decrease', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: Activity increase', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: Low heat stress', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: Medium heat stress', unit: '0-1')
    SensorType.find_or_create_by(property: 'Event: High heat stress', unit: '0-1')
  end

  desc "update sensor reading timestamps to cest"
  task update_timestamps: :environment do
    Sensor::Reading.where.not(smaxtec_timestamp: nil).each do |reading|
      # set time -2 (so timezone gets calculated right in cest)
      reading.created_at = reading.created_at - 2.hours
      reading.save
    end
    #smaxtec_api_controller = SmaxtecApi.new
    #smaxtec_api_controller.update_sensor_readings
    #smaxtec_api_controller.update_events
  end
end
