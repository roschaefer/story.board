class SmaxtecApi
  require 'net/http'

  SMAXTEC_API_EMAIL = Rails.application.secrets.smaxtec_api_email
  SMAXTEC_API_PASSWORD = Rails.application.secrets.smaxtec_api_password
  SMAXTEC_API_BASE_URL = 'https://api-staging.smaxtec.com/api/v1'
  PROPERTY_MAPPING = {'Temperature' => 'temp'}

  def update_sensor_readings
    Sensor.where.not(animal_id: nil).each do |sensor|
      reading = last_smaxtec_sensor_reading(sensor)
      unless reading.save
        puts reading.errors
        # goodbye
      end
    end
  end


  def last_smaxtec_sensor_reading(sensor)
    metric = PROPERTY_MAPPING[sensor.property]
    return nil unless metric
    jwt_request = get_jwt
    return nil unless jwt_request # TODO: shouldn't we distinguish erroneous jwt requests?

    @jwt = JSON.parse(jwt_request)['token']
    #animal_id = '5722099ea80a5f54c631513d' # name = Arabella
    temp_data = send_api_request('/data/query', { :animal_id => sensor.animal_id, :metric => metric, :from_date => Time.now.to_i - 3600, :to_date => Time.now.to_i })
    if temp_data && temp_data['data'].count > 1
      value = temp_data['data'].last[1] # WTF?
      return Sensor::Reading.new(sensor: sensor, calibrated_value: value, uncalibrated_value: value)
    else
      return nil
    end
  end


  def get_jwt
    uri = URI(SMAXTEC_API_BASE_URL + '/user/get_token')
    params = { :email => SMAXTEC_API_EMAIL, :password => SMAXTEC_API_PASSWORD }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)

    return nil unless response.is_a?(Net::HTTPSuccess)
    response.body
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

    return nil unless response.is_a?(Net::HTTPSuccess)
    JSON.parse(response.body)
  end

end
