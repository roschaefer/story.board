require 'rails_helper'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
end

RSpec.describe SmaxtecApi do
    let(:smaxtec_api) { SmaxtecApi.new() }

  describe '.get_temeperature' do
    it 'should read the current temperature of a specified animal from the Smaxtec API' do
      VCR.use_cassette('smaxtec_api', :record => :new_episodes) do
        expect(smaxtec_api.get_temperature()).to be_kind_of(Float)
      end
    end
  end
end
