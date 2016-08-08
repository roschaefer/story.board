require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

describe Sensor, type: :model do
  context 'without a name' do
    specify { expect(build(:sensor, name: '')).not_to be_valid }
  end

  context 'without a report' do
    specify { expect(build(:sensor, report: nil)).not_to be_valid }
  end

  describe '#name' do
    it_behaves_like 'database unique attribute', :sensor, name: 'XYZ'
  end

  describe '#address' do
    context 'different name' do
      it_behaves_like 'database unique attribute', :sensor, name: 'Whatever', address: 123
    end
  end

  describe '#destroy' do
    it 'destroys all associated readings' do
      sensor = create(:sensor)
      create :sensor_reading, sensor: sensor
      expect { sensor.destroy }.to change { Sensor::Reading.count }.from(1).to(0)
    end
  end

  describe '#address' do
    it 'accepts hex numbers and saves as decimal' do
      sensor = build(:sensor, :address => "0xBC")
      sensor.save
      expect(sensor).to be_valid
      expect(sensor.address).to eq 188
    end
  end
end
