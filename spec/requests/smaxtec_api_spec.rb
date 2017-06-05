require 'rails_helper'

RSpec.describe 'Smaxtec API', type: :request do

  describe 'GET' do
    let(:url) { '/smaxtec_api/temperature' }

    it 'reads temperature from Test API' do
      get url
      expect(response).to have_http_status(200)

      json_response = JSON.parse(response.body)
      expect(json_response.keys).to contain_exactly('temperature')
    end
  end
end
