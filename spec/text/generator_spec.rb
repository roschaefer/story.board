require 'rails_helper'

RSpec.describe Text::Generator do
  let(:sensor_type)    { create(:sensor_type, property: 'Temperature', unit: '°C') }
  let(:sensor)         { create(:sensor, name: 'SensorXY', sensor_type: sensor_type) }
  let(:reading)        { create(:sensor_reading, sensor: sensor, calibrated_value: 5) }
  let(:condition)      { create(:condition, sensor: sensor, text_component: text_component, from: 0, to: 10) }
  let(:text_component) { create(:text_component, main_part: main_part) }
  let(:main_part)      { "some content" }
  let(:report)         { create(:report, text_components: [text_component]) }

  context 'given sensor data and text components' do
    before { report; condition; reading }

    describe '#generate' do
      subject { described_class.generate(report) }
      it { is_expected.to have_value("some content")}


      context 'with markup' do
        let(:main_part)      { 'Sensor value: { SensorXY }' }
        it('renders sensor value') { is_expected.to have_value('Sensor value: 5.0°C')}
      end

      context 'with markup for missing sensor' do
        let(:main_part)       { 'Sensor value: { SensorAB }' }
        it('will be ignored') { is_expected.to have_value('Sensor value: { SensorAB }')}
      end
    end
  end
end
