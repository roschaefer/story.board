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

  describe '.get_sensor_readings' do
    let(:report) { Report.find(1) }
    let(:sensor_type) { SensorType.find(1) }
    let(:temperature_sensor) { Sensor.find_by(name: 'Kuh Berta Temperature') }

    it 'should get the sensor readings from the Smaxtec API and create them in the system' do
      VCR.use_cassette('smaxtec_api', :record => :once) do
        number_sensor_readings = temperature_sensor.sensor_readings.count
        smaxtec_api.get_sensor_readings
        expect(number_sensor_readings).to eq (number_sensor_readings + 1)
      end
    end
  end
end
