class SmaxtecApi
  require 'net/http'

  SMAXTEC_API_EMAIL = Rails.application.secrets.smaxtec_api_email
  SMAXTEC_API_PASSWORD = Rails.application.secrets.smaxtec_api_password
  SMAXTEC_API_BASE_URL = 'https://api-staging.smaxtec.com/api/v1'
  PROPERTY_MAPPING = {'Temperature' => 'temp', 'pH Value' => 'ph', 'Movement' => 'act'}

  def update_sensor_readings
    abort("missing SMAXTEC_API_EMAIL and SMAXTEC_API_PASSWORD") unless SMAXTEC_API_PASSWORD && SMAXTEC_API_PASSWORD
    Sensor.where.not(animal_id: nil).each do |sensor|
      puts "Getting latest sensory data from Smaxtec for sensor: #{sensor.name}"
      reading = last_smaxtec_sensor_reading(sensor)
      if reading
        if reading.save
          puts "New reading: #{reading.calibrated_value}"
        else
          puts reading.errors
        end
      else
        puts "No sensor reading for sensor: #{sensor.name}"
      end
    end
  end


  def last_smaxtec_sensor_reading(sensor)
    metric = PROPERTY_MAPPING[sensor.property]
    unless metric
      puts "Sensor #{sensor.name} has unrecognized property: #{sensor.property}"
      return nil
    end
    #animal_id = '5722099ea80a5f54c631513d' # name = Arabella
    temp_data = send_api_request('/data/query', { :animal_id => sensor.animal_id, :metric => metric, :from_date => Time.now.to_i - 3600, :to_date => Time.now.to_i })

    if temp_data && temp_data['data'].count > 1
      last_entry = temp_data['data'].last
      timestamp = last_entry[0]
      value = last_entry[1]
      return Sensor::Reading.find_or_create_by(sensor_id: sensor.id, smaxtec_timestamp: timestamp) do |reading|
        reading.calibrated_value = value
        reading.uncalibrated_value = value
      end
    else
      return nil
    end
  end


  def get_jwt
    uri = URI(SMAXTEC_API_BASE_URL + '/user/get_token')
    params = { :email => SMAXTEC_API_EMAIL, :password => SMAXTEC_API_PASSWORD }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)

    case response
    when Net::HTTPSuccess
      return JSON.parse(response.body)['token']
    else
      puts "SMAXTEC_EMAIL: #{SMAXTEC_API_EMAIL}"
      puts "SMAXTEC_PASSWORD: #{SMAXTEC_API_PASSWORD}"
      puts response
      abort('JWT authentication failed')
    end
  end


  def send_api_request(url, params=nil)
    @jwt ||= get_jwt
    uri = URI(SMAXTEC_API_BASE_URL + url)

    if params
      uri.query = URI.encode_www_form(params)
    end

    http = Net::HTTP.new(uri.host, uri.port)
    #http.set_debug_output($stdout)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    req['Authorization'] = 'Bearer ' + @jwt
    response = http.request(req)

    case response
    when Net::HTTPSuccess
      return JSON.parse(response.body)
    else
      puts response
      puts 'API request failed'
    end
  end

end
