require 'rails_helper'

RSpec.describe 'Add sensor reading manually', type: :request do

  describe 'POST /sensor_readings' do
    let(:sensor_reading_params) { { sensor_id: sensor.id, calibrated_value: 25.4, uncalibrated_value: 26.7, created_at: '2011-11-11 11:11:11' } }
    let(:sensor) { create(:sensor) }
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:url) { '/sensor_readings' }

    it 'create sensor reading' do
      expect { post url, params: { sensor_reading: sensor_reading_params }, headers: headers }.to change { Sensor::Reading.count }.from(0).to(1)
    end

    it 'requires sensor_id' do
      post url, params: { sensor_reading: sensor_reading_params.merge(sensor_id: nil) }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'requires calibrated_value' do
      post url, params: { sensor_reading: sensor_reading_params.merge(calibrated_value: nil) }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'requires uncalibrated_value' do
      post url, params: { sensor_reading: sensor_reading_params.merge(uncalibrated_value: nil) }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns generated sensor readings as json' do
      post url, params: {sensor_reading: sensor_reading_params, format: :json}
      expect(JSON.parse(response.body).size).to eq 8
      expect(JSON.parse(response.body)['created_at']).to eq '2011-11-11T11:11:11.000Z'
    end
  end
end
