require "rails_helper"

describe Sensor, :type => :model do
  context "without a name" do
    specify { expect(Sensor.new(:name => "")).not_to be_valid }
  end

  context "duplicate name" do
    before { create :sensor, :name => "XYZ" }

    specify { expect{ create(:sensor, :name => "XYZ")}.to raise_exception( ActiveRecord::RecordNotUnique ) }
  end

  describe "#destroy" do
    it "destroys all associated readings" do
      sensor = create(:sensor)
      create :sensor_reading, :sensor => sensor
      expect{sensor.destroy}.to change{Sensor::Reading.count}.from(1).to(0)
    end
  end
end
