require 'rails_helper'

RSpec.describe SensorDecorator do
  let(:sensor)         { create(:sensor, name: 'SensorXY', sensor_type: sensor_type ) }
  let(:sensor_type)    { create(:sensor_type, property: 'Temperature', unit: '°C') }

  subject { described_class.new sensor }

  describe '#last_value' do

    context 'sensory data available' do

      before {
        create(:sensor_reading, sensor: sensor, calibrated_value: 5, release: :final)
        create(:sensor_reading, sensor: sensor, calibrated_value: -3, release: :debug)
      }

      context 'release :final' do
        subject { super().last_value }
        it { is_expected.to eq '5.0 °C'}
      end

      context 'release :debug' do
        subject { super().last_value(DiaryEntry.new(release: :debug)) }
        it { is_expected.to eq '-3.0 °C'}
      end

    end

    context 'missing sensory data' do
      subject { super().last_value() }
      it { is_expected.to eq '-- missing sensory data --' }
    end

  end
end
