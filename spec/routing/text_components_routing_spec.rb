require "rails_helper"

RSpec.describe TextComponentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/reports/1/text_components").to route_to("text_components#index", report_id: '1')
    end

    it "routes to #create" do
      expect(:post => "/reports/1/text_components").to route_to("text_components#create", report_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/reports/1/text_components/1").to route_to("text_components#update", report_id: '1', id: "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/reports/1/text_components/1").to route_to("text_components#update", report_id: '1', id: "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/reports/1/text_components/1").to route_to("text_components#destroy", report_id: '1', id: "1")
    end

  end
end
