require "rails_helper"

describe Sensor, :type => :model do
  context "without a name" do
    specify { expect(Sensor.new(:name => "")).not_to be_valid }
  end

  describe "#destroy" do
    it "also destroys all associated readings" do
      sensor = create(:sensor)
      create :sensor_reading, :sensor => sensor
      expect{sensor.destroy}.to change{SensorReading.count}.from(1).to(0)
    end
  end
end
