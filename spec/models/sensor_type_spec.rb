require 'rails_helper'

RSpec.describe SensorType, type: :model do
  it 'validates unit to be present, to avoid NaN in javascript' do
    expect(build(:sensor_type, unit: nil)).not_to be_valid
  end

  it 'unit may be blank' do
    expect(build(:sensor_type, unit: '')).to be_valid
  end
end
