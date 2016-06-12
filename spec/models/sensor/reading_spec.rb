require 'rails_helper'

describe Sensor::Reading, type: :model do
  context 'without a correspondent sensor' do
    specify { expect(build(:sensor_reading, sensor: nil)).not_to be_valid }
  end

  [:calibrated_value, :uncalibrated_value].each do |attribute|
    describe attribute do
      it "stores float values" do
        reading = build(:sensor_reading, attribute => 0.5)
        expect(reading.send(attribute)).to eq 0.5
      end
    end
  end
end
