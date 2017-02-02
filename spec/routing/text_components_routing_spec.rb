require "rails_helper"

RSpec.describe TextComponentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/text_components").to route_to("text_components#index")
    end

    it "routes to #show" do
      expect(:get => "/text_components/1").to route_to("text_components#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/text_components").to route_to("text_components#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/text_components/1").to route_to("text_components#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/text_components/1").to route_to("text_components#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/text_components/1").to route_to("text_components#destroy", :id => "1")
    end

  end
end
