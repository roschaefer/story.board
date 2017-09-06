require 'rails_helper'

RSpec.describe SensorType, type: :model do
  it 'validates unit to be present, to avoid NaN in javascript' do
    expect(build(:sensor_type, unit: nil)).not_to be_valid
  end

  it 'unit may be blank' do
    expect(build(:sensor_type, unit: '')).to be_valid
  end

  describe '#fractionDigits' do
    context 'missing', issue: 666 do
      let(:sensor_type) { build(:sensor_type, fractionDigits: nil)}
      subject { sensor_type }
      it { is_expected.not_to be_valid }
    end
  end
end
