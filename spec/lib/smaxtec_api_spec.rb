require 'rails_helper'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.default_cassette_options = {
    :match_requests_on => [:method,
                           VCR.request_matchers.uri_without_param(:from_date, :to_date, :email, :password)]
  }
end

RSpec.describe SmaxtecApi do
  let(:smaxtec_api) { SmaxtecApi.new() }
  let(:sensor_type) { create(:sensor_type, property: 'Temperature', unit: '°C') }
  let(:sensor) { create(:sensor, name: 'Kuh Berta Temperature Test Sensor', sensor_type: sensor_type, animal_id: '5722099ea80a5f54c631513d') }

  describe '.last_smaxtec_sensor_reading' do
      subject {
        VCR.use_cassette('smaxtec_api', :record => :once) do
          smaxtec_api.last_smaxtec_sensor_reading(sensor)
        end
      }

      it { is_expected.to be_a Sensor::Reading }
  end

  describe '.update_sensor_readings' do

    it 'should update the sensor readings from the Smaxtec API and integrate them to the system' do
      VCR.use_cassette('smaxtec_api', :record => :once) do
        sensor # create
        expect { smaxtec_api.update_sensor_readings }.to change {Sensor::Reading.count}.from(0).to(1)
      end
    end
  end

  describe '.update_sensor_readings' do

    it 'should not create a sensor reading if the sensor reading for the specific sensor type already exists' do
      sensor # create
      VCR.use_cassette('smaxtec_api', :record => :once) do
        expect { smaxtec_api.update_sensor_readings }.to change {Sensor::Reading.count}.from(0).to(1)
      end

      VCR.use_cassette('smaxtec_api', :record => :once) do
        expect { smaxtec_api.update_sensor_readings }.to_not change {Sensor::Reading.count}
      end
    end
  end
end
