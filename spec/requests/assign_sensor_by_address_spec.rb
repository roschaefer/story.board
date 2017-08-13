require 'rails_helper'

RSpec.describe 'Assign sensor by address', type: :request do
  let(:report) { create(:report) }
  let(:sensor) { create(:sensor, report: report) }
  let(:sensor_reading_params) {
    {
      "event": "measurement",
      "data": "{ \"calibrated_value\": 47, \"uncalibrated_value\": 11, \"sensor\": { \"address\": 456 } }",
      "published_at": "2016-06-05T13:41:18.705Z",
      "coreid": "1e0033001747343339383037"
    }
  }

  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:sensor_id) { sensor.id }
  let(:url) { "/reports/#{report.id}/sensors/#{sensor_id}/sensor_readings" }
  context "multiple sensors" do
    let(:temperature) { create(:sensor, :address => 123) }
    let(:light) { create(:sensor, :address => 456) }
    before do
      temperature
      light
    end

    it "creates a sensor reading" do
      expect { post url, params: sensor_reading_params , headers: headers }.to change { Sensor::Reading.count }.from(0).to(1)
    end

    it "assigns the correct sensor" do
      post url, params: sensor_reading_params, headers: headers
      expect(Sensor::Reading.first.sensor).to eq light
    end

    context 'sensor params empty' do
      let(:sensor_reading_params) { super().merge(data: "{ \"calibrated_value\": 47, \"uncalibrated_value\": 11 }") }

      context 'and no sensor for given id' do
        let(:sensor_id) { 4711 }

        it "does not create a sensor reading" do
          expect{ post url,  params: sensor_reading_params, headers: headers }.to raise_error( ActiveRecord::RecordNotFound )
          expect(Sensor::Reading.count).to eq 0
        end
      end
    end
  end
end
