require "rails_helper"

describe Sensor, :type => :model do
  context "without a name" do
    specify { expect(Sensor.new(:name => "")).not_to be_valid }
  end
end
