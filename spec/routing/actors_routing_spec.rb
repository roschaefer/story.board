require "rails_helper"

RSpec.describe ActuatorsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/actuators").to route_to("actuators#index")
    end

    it "routes to #new" do
      expect(:get => "/actuators/new").to route_to("actuators#new")
    end

    it "routes to #show" do
      expect(:get => "/actuators/1").to route_to("actuators#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/actuators/1/edit").to route_to("actuators#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/actuators").to route_to("actuators#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/actuators/1").to route_to("actuators#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/actuators/1").to route_to("actuators#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/actuators/1").to route_to("actuators#destroy", :id => "1")
    end

  end
end
