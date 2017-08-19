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

  describe '#device_id' do
      context 'of two sensors with the same sensor type', issue: 474 do
        before { create(:sensor_type, id: 11) }
        it_behaves_like 'database unique attribute', :sensor, sensor_type_id: 11, device_id: 123
        context 'if #device_id is blank' do
          before { create(:sensor, sensor_type_id: 11, device_id: '') }
          subject { build(:sensor, sensor_type_id: 11, device_id: '') }
          it { is_expected.to be_valid }
          it { expect{ subject.save!(validate: false) }.not_to raise_error }
        end
      end
  end

  describe '#animal_id' do
    context 'of two sensors with the same sensor type', issue: 500 do
      before { create(:sensor_type, id: 11) }
      it_behaves_like 'database unique attribute', :sensor, sensor_type_id: 11, animal_id: 123
      context 'if #animal_id is blank' do
        before { create(:sensor, sensor_type_id: 11, animal_id: '') }
        subject { build(:sensor, sensor_type_id: 11, animal_id: '') }
        it { is_expected.to be_valid }
        it { expect{ subject.save!(validate: false) }.not_to raise_error }
      end
    end
  end

  describe '#last_reading' do
    let(:sensor) { build(:sensor) }
    let(:first) { create(:sensor_reading, sensor: sensor, created_at: 5.seconds.ago) }
    let(:second) { create(:sensor_reading, sensor: sensor, created_at: Time.now) }
    before { first; second }

    it 'returns last sensor reading by default' do
      expect(sensor.last_reading).to eq second
    end

    it 'returns last sensor reading at a given point in time' do
      diary_entry = DiaryEntry.new(moment: 3.seconds.ago)
      expect(sensor.last_reading diary_entry).to eq first
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

  describe '#calibrate' do
    let(:sensor) { create(:sensor) }
    it 'might update both values at once' do
      sensor_reading = Sensor::Reading.new(uncalibrated_value: 7.0)
      sensor.calibrate(sensor_reading)
      expect(sensor.max_value).to eq 7.0
      expect(sensor.min_value).to eq 7.0
    end

    it 'behaves robust against nil values' do
      sensor_reading = Sensor::Reading.new
      sensor.calibrate(sensor_reading)
      expect(sensor.max_value).to be_nil
      expect(sensor.min_value).to be_nil
    end
  end
end
