require 'rails_helper'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.default_cassette_options = {
    :match_requests_on => [:method,
      VCR.request_matchers.uri_without_param(:from_date, :to_date)]
  }
end

RSpec.describe SmaxtecApi do
    let(:smaxtec_api) { SmaxtecApi.new() }

  describe '.get_temperature' do
    it 'should read the current temperature of a specified animal from the Smaxtec API' do
      VCR.use_cassette('smaxtec_api', :record => :once) do
        expect(smaxtec_api.get_temperature()).to be_kind_of(Float)
      end
    end
  end
end
