class SmaxtecApi
  require 'net/http'

  SMAXTEC_API_EMAIL = Rails.application.secrets.smaxtec_api_email
  SMAXTEC_API_PASSWORD = Rails.application.secrets.smaxtec_api_password
  SMAXTEC_API_BASE_URL = 'https://api-staging.smaxtec.com/api/v1'

  def get_sensor_readings

    #define animal_id for Cows: topic_id => animal_id
    animal_ids = { 1 => '5722099ea80a5f54c631513d' }

    # Get Temperature for Cows

    # Assuming 1 report = 1 cow, otherwise get just the specified reports
    Report.all.each do |report|
      if animal_ids[report.id]
        sensors = Sensor.where(report_id: report.id, smaxtec_sensor: true)

        if sensors
          binding.pry
          sensors.each do |sensor|
            # temperature sensor
            if sensor.sensor_type == 1
                #get temperature data & write to sensor readings
            end
          end
        end
      end
    end

  end

  def get_temperature(animal_id)
    jwt_request = get_jwt

    if jwt_request
      @jwt = JSON.parse(jwt_request)['token']
      organisation_id ='5721e3f8a80a5f54c6315131';
      #animal_id = '5722099ea80a5f54c631513d' # name = Arabella
      metric = 'temp'
      unit = 'degree_celsius'
      temp_data = send_api_request('/data/query', { :animal_id => animal_id, :metric => metric, :from_date => Time.now.to_i - 3600, :to_date => Time.now.to_i, :aggregation => 'hourly.mean' })

      if temp_data && temp_data['data'].count() > 1
        #sensor_reading = Sensor::Reading.new(sensor_id: 4, calibrated_value: temp_data['data'].last[1], uncalibrated_value: temp_data['data'].last[1])
        #sensor_reading.save
        return temp_data['data'].last[1]
      else
        return false
      end

    else
      return false
    end
  end

  def get_jwt
    uri = URI(SMAXTEC_API_BASE_URL + '/user/get_token')
    params = { :email => SMAXTEC_API_EMAIL, :password => SMAXTEC_API_PASSWORD }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)

    if !response.is_a?(Net::HTTPSuccess)
      return false
    end

    return response.body
  end

  def send_api_request(url, params=nil)
    uri = URI(SMAXTEC_API_BASE_URL + url)

    if params
      uri.query = URI.encode_www_form(params)
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    req['Authorization'] = 'Bearer ' + @jwt
    response = http.request(req)

    if !response.is_a?(Net::HTTPSuccess)
      return false
    end

    return JSON.parse(response.body)
  end

end
