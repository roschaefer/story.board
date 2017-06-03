class SmaxtecsApiController < ApplicationController
  require 'net/http'

  TOKEN_EMAIL = 'superkuh@hooli.xyz'
  TOKEN_PASSWORD = 'pansen123'
  API_BASE_URL = 'https://api-staging.smaxtec.com/api/v1'

  def get_temperature
    jwt_request = get_jwt
    @jwt = JSON.parse(jwt_request)['token']

    if @jwt
      # user = send_api_request('/user')
      # organisation_id = user["user_organisations"][0]["organisation_id"]
      organisation_id ='5721e3f8a80a5f54c6315131';
      #send_api_request('/animal/by_organisation', { :organisation_id => organisation_id})[0]['_id']
      animal_id = '5722099ea80a5f54c631513d' # name = Arabella
      # send_api_request('/data/metrics', { :animal_id => animal_id})
      metric = 'temp'
      unit = 'degree_celsius'
      #send_api_request('/data/query', { :animal_id => animal_id, :metric => metric, :from_date => Time.now.to_i - 3600, :to_date => Time.now.to_i, :aggregation => 'hourly.mean' })
      temp_data = send_api_request('/data/query', { :animal_id => animal_id, :metric => metric, :from_date => Time.now.to_i - 3600, :to_date => Time.now.to_i, :aggregation => 'hourly.mean' })

      if temp_data && temp_data['data'].count() > 1
        render :json => { temperature: temp_data['data'].last[1] }
      else
        render json: {}, status: 404
      end


    else
      render json: {}, status: 404
    end
  end

  def get_jwt
    uri = URI(API_BASE_URL + '/user/get_token')
    params = { :email => TOKEN_EMAIL, :password => TOKEN_PASSWORD }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)

    if !response.is_a?(Net::HTTPSuccess)
      return false
    end

    return response.body
  end

  def send_api_request(url, params=nil)
    uri = URI(API_BASE_URL + url)

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
