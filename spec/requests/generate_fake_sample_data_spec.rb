require 'rails_helper'

RSpec.describe 'Generate debug Sample Data', type: :request do
  let(:report) { create(:report) }
  let(:sensor) { create(:sensor, report: report) }

  describe 'POST /sensor_readings/debug' do
    let(:sample_params) { { quantity: 3, from: 1, to: 2 } }
    let(:sensor) { create(:sensor) }
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:url) { "/reports/#{report.id}/sensors/#{sensor.id}/sensor_readings/debug" }

    it 'generates sample data for a sensor' do
      expect { post url, params: { sample: sample_params }, headers: headers }.to change { Sensor::Reading.count }.from(0).to(3)
    end

    it 'requires upper and lower bounds' do
      post url, params: { sample: sample_params.merge(to: nil) }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'lower bound must smaller than upper bound' do
      post url, params: { sample: sample_params.merge(from: 4, to: 3) }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns generated sensor readings as json' do
      post url, params: {sample: sample_params, format: :json}
      expect(JSON.parse(response.body).size).to eq 3
    end
  end
end
