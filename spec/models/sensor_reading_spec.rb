require "rails_helper"

describe SensorReading, :type => :model do
  context "without a correspondent sensor" do
    specify { expect(SensorReading.new(:sensor => nil)).not_to be_valid }
  end
end
