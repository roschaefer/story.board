require 'rails_helper'

describe Sensor::Reading, type: :model do
  context 'without a correspondent sensor' do
    specify { expect(build(:sensor_reading, sensor: nil)).not_to be_valid }
  end
end
