require 'rails_helper'

RSpec.describe Sensor::Reading, type: :request do
  let(:headers) {
    {
    'ACCEPT' => 'application/json',
    'Content-Type' => "application/json"
    }
  }
  let(:url) { '/sensor_readings' }
  let(:request) { post url, params: params.to_json, headers: headers }

  context 'sensor is calibrating' do
    let(:sensor) { create(:sensor, id: 123, calibrating: true) }

    describe 'sensor id is missing' do
      let(:params) {
        {
          sensor_id: nil,
          uncalibrated_value: 5.0,
        }
      }
      it 'does not change sensor calibration' do
        expect{ request }.not_to change{sensor.reload; sensor.min_value}
      end

      it 'does not create any sensor reading' do
        expect{ request }.not_to change{Sensor::Reading.count}.from(0)
      end
    end

    context "given sensor and id" do
      let(:params) {
        {
          sensor_id: sensor.id,
          uncalibrated_value: 5.0,
        }
      }

      it 'changes sensor calibration' do
        login_user
        expect{ request }.to change{sensor.reload; sensor.min_value}.to(5.0)
      end

      it 'does not create any sensor reading' do
        expect{ request }.not_to change{Sensor::Reading.count}.from(0)
      end

    end
  end
end
