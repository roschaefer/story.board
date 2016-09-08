require 'rails_helper'

RSpec.describe SensorDecorator do
  let(:sensor)         { create(:sensor, name: 'SensorXY', sensor_type: sensor_type ) }
  let(:sensor_type)    { create(:sensor_type, property: 'Temperature', unit: '°C') }
  let(:reading)        { create(:sensor_reading, sensor: sensor, calibrated_value: 5) }

  before  { reading }
  subject { described_class.new sensor }

  describe '#last_value' do
    subject { super().last_value }
    it { is_expected.to eq '5.0°C'}
    context 'intention :fake' do
      before  { create(:sensor_reading, sensor: sensor, calibrated_value: -3, intention: :fake) }
      subject { described_class.new(sensor).last_value(intention: :fake) }
      it { is_expected.to eq '-3.0°C'}
    end
  end
end
