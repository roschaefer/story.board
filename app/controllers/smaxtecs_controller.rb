class SmaxtecsController < ApplicationController
  require 'net/http'

  TOKEN_EMAIL = 'superkuh@hooli.xyz'
  TOKEN_PASSWORD = 'pansen123'
  API_BASE_URL = 'https://api-staging.smaxtec.com/api/v1'

  def show
    jwt_request =  get_jwt

    if jwt_request.is_a?(Net::HTTPSuccess)
      jwt = JSON.parse(jwt_request.body)
      render :text => jwt['token']
    else
      render :text => 'error'
    end
  end

  def get_jwt
    #params = {"email": @email, "password": @pwd}

    uri = URI(API_BASE_URL + '/user/get_token')
    params = { :email => TOKEN_EMAIL, :password => TOKEN_PASSWORD }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)

    return response
    #req = requests.get(api_base_url + "/user/get_token", params=params)
  end

  def send_api_request
  end

end
