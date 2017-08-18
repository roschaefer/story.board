require 'rails_helper'

RSpec.describe TextComponentDecorator do
  let(:decorator) { TextComponentDecorator.new(text_component, diary_entry) }
  let(:text_component) { create(:text_component, heading: '{ value(1) } outside!') }
  let(:diary_entry) { create(:diary_entry) }
  let(:sensor) { create(:sensor, id: 1, sensor_type: sensor_type)}
  let(:sensor_reading) { create(:sensor_reading, sensor: sensor, calibrated_value: 21)}
  let(:sensor_type) { create(:sensor_type, property: 'temperature', unit: '°C') }

  before { sensor_reading }

  describe '#heading' do
    subject { decorator.heading }
    it 'renders markup' do
      is_expected.to eq('21.0 °C outside!')
    end
  end
end
