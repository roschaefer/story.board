require 'rails_helper'

RSpec.describe Text::Generator do
  let(:report)         { create(:report) }
  let(:intention)      { :real }
  subject { described_class.new( report, intention) }

  describe '#choose_heading' do
    subject { super().choose_heading }
    let(:report) { create(:report, text_components: text_components) }

    context 'for text components with several headings and priorities' do
      let(:text_components) do
        [:low, :medium, :high].collect { |p| create(:text_component, heading: "Heading with priority #{p}", priority: p) }
      end
      it { is_expected.to eq 'Heading with priority high'}
    end

    context 'for text components with several headings but without priorities' do
      let(:text_components) do
        [:low, :medium, :high].collect { |p| create(:text_component, heading: "Heading with priority #{p}", priority: nil) }
      end
      it { is_expected.to include 'Heading'} # any of those headings
    end
  end

  describe '#generate' do
    subject { super().generate }

    it { is_expected.to eq({heading: '', introduction: '', main_part: '', closing: ''}) }

    context 'given text components' do
      let(:report)         { create(:report, text_components: [text_component]) }
      let(:text_component) { create(:text_component, main_part: main_part) }
      let(:main_part)      { "some content" }

      it { is_expected.to have_value("some content")}

      describe 'report markup' do
        describe 'report name' do
          let(:report)    { create(:report, text_components: [text_component], name: 'Foobar') }
          let(:main_part) { "Say something about { report}." }
          it { is_expected.to have_value("Say something about Foobar.")}
        end

        describe 'report variables' do
          let(:report)    { create(:report, text_components: [text_component], variables: [variable]) }
          let(:variable)  { create(:variable, key: 'cool_thing', value: 'sth. cool') }
          let(:main_part) { "Say something about { cool_thing }." }
          it { is_expected.to have_value("Say something about sth. cool.")}
        end
      end

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

          context 'with markup for sensor' do
            let(:main_part)      { 'Sensor value: { SensorXY }' }
            it('renders sensor value') { is_expected.to have_value('Sensor value: 5.0°C')}
            context 'but with sensor data of different intention' do
              before { reading; create(:sensor_reading, sensor: sensor, intention: :fake, calibrated_value: 0) }

              context 'render :fake report' do
                let(:intention) { :fake }
                it { is_expected.to have_value('Sensor value: 0.0°C')}
              end

              context 'render :real report' do
                let(:intention) { :real }
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
