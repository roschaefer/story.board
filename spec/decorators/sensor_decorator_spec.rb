require 'rails_helper'

RSpec.describe SensorDecorator do
  let(:sensor)         { create(:sensor, name: 'SensorXY', sensor_type: sensor_type ) }
  let(:sensor_type)    { create(:sensor_type, property: 'Temperature', unit: '°C', fractionDigits: 0) }

  let(:diary_entry) { DiaryEntry.new(release: :final) }
  let(:decorator) { described_class.new(sensor, diary_entry) }
  subject { decorator }

  describe '#last_value' do
    subject { decorator.last_value }

    context 'sensory data available' do
      describe '#fractionDigits', issue: 666 do
        let(:sensor_type) { create(:sensor_type, property: 'Temperature', unit: '°C', fractionDigits: 5) }
        it { is_expected.to eq('5.00000 °C')}
      end

      before {
        create(:sensor_reading, sensor: sensor, calibrated_value: 5, release: :final)
        create(:sensor_reading, sensor: sensor, calibrated_value: -3, release: :debug)
      }

      context 'release :final' do
        it { is_expected.to eq '5 °C'}
      end

      context 'release :debug' do
        let(:diary_entry) { DiaryEntry.new(release: :debug) }
        it { is_expected.to eq '-3 °C'}
      end

    end

    context 'missing sensory data' do
      it { is_expected.to eq '(Sorry, leider habe ich gerade keine Daten für dich!)' }
    end

  end
end
