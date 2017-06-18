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

  describe '.get_temperature' do
    it 'should read the current temperature of a specified animal from the Smaxtec API' do
      VCR.use_cassette('smaxtec_api', :record => :once) do
        expect(smaxtec_api.get_temperature('5722099ea80a5f54c631513d')).to be_kind_of(Float)
      end
    end
  end

  describe '.update_sensor_readings' do
    let(:sensor_type) { create(:sensor_type, property: 'Temperature', unit: '°C') }
    let(:sensor) { create(:sensor, name: 'Kuh Berta Temperature Test Sensor', sensor_type: sensor_type, animal_id: '5722099ea80a5f54c631513d') }

    it 'should update the sensor readings from the Smaxtec API and integrate them to the system' do
      VCR.use_cassette('smaxtec_api', :record => :once) do
        new_sensor = sensor
        expect { smaxtec_api.update_sensor_readings }.to change {Sensor::Reading.count}.from(0).to(1)
      end
    end
  end
end
