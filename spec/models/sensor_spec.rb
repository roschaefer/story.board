require "rails_helper"

describe Sensor, :type => :model do
  context "without a name" do
    specify { expect(Sensor.new(:name => "")).not_to be_valid }
  end

  context "duplicate name" do
    before { create :sensor, :name => "XYZ" }

    specify { expect{ build(:sensor, :name => "XYZ").save(:validate => false)}.to raise_exception( ActiveRecord::RecordNotUnique ) }
    specify { expect(build(:sensor, :name => "XYZ")).not_to be_valid }
  end

  describe "#destroy" do
    it "destroys all associated readings" do
      sensor = create(:sensor)
      create :sensor_reading, :sensor => sensor
      expect{sensor.destroy}.to change{Sensor::Reading.count}.from(1).to(0)
    end
  end


  describe "#active_text_components" do
    let (:sensor) { create(:sensor) }

    it "returns empty list if there are no sensor readings" do
      expect(sensor.active_text_components).to eq []
    end

    context "with a sensor reading" do
      before do
        create(:sensor_reading, :sensor => sensor, :calibrated_value => 47)
      end


      context "without arguments" do

        it "considers text components for the last sensor reading" do
          text_component = create(:text_component, :main_part => "Some Text")
          create(:condition, :text_component => text_component,
                 :sensor => sensor, :from => 10, :to => 100)
          expect(sensor.active_text_components).to include(text_component)
        end

        it "considers no text component if the last sensor reading is not in the interval" do
          text_component = create(:text_component, :main_part => "Some Text")
          create(:condition, :text_component => text_component,
                 :sensor => sensor, :from => 50, :to => 100)
          expect(sensor.active_text_components).not_to include(text_component)
        end

      end
    end
  end
end
