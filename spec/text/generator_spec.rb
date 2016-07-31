require 'rails_helper'

RSpec.describe Text::Generator do
  let(:report)         { create(:report) }

  describe '#generate' do
    subject { described_class.generate(report) }

    it { is_expected.to eq({heading: '', introduction: '', main_part: '', closing: ''}) }

    context 'given text components' do
      let(:report)         { create(:report, text_components: [text_component]) }
      let(:text_component) { create(:text_component, main_part: main_part) }
      let(:main_part)      { "some content" }

      it { is_expected.to have_value("some content")}

      context 'given a condition' do
        let(:condition)      { create(:condition, sensor: sensor, text_component: text_component, from: 0, to: 10) }
        let(:sensor)         { create(:sensor, name: 'SensorXY', sensor_type: sensor_type) }
        let(:sensor_type)    { create(:sensor_type, property: 'Temperature', unit: '°C') }
        before { condition }
        it('condition must hold') { is_expected.to eq({heading: '', introduction: '', main_part: '', closing: ''}) }


        context 'given sensor data' do
          let(:reading)        { create(:sensor_reading, sensor: sensor, calibrated_value: 5) }
          before { report; reading }

          it { is_expected.to have_value("some content")}


          context 'with markup' do
            let(:main_part)      { 'Sensor value: { SensorXY }' }
            it('renders sensor value') { is_expected.to have_value('Sensor value: 5.0°C')}
            context 'but with sensor data of different intention' do
              before { reading; create(:sensor_reading, sensor: sensor, intention: :fake, calibrated_value: 0) }

              context 'render :fake report' do
                subject { described_class.generate(report, :fake) }
                it { is_expected.to have_value('Sensor value: 0.0°C')}
              end

              context 'render :real report' do
                subject { described_class.generate(report, :real) }
                it { is_expected.to have_value('Sensor value: 5.0°C')}
              end
            end
          end

          context 'with markup for missing sensor' do
            let(:main_part)       { 'Sensor value: { SensorAB }' }
            it('will be ignored') { is_expected.to have_value('Sensor value: { SensorAB }')}
          end
        end
      end
    end
  end
end
