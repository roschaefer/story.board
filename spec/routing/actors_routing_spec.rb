require "rails_helper"

RSpec.describe ActorsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/actors").to route_to("actors#index")
    end

    it "routes to #new" do
      expect(:get => "/actors/new").to route_to("actors#new")
    end

    it "routes to #show" do
      expect(:get => "/actors/1").to route_to("actors#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/actors/1/edit").to route_to("actors#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/actors").to route_to("actors#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/actors/1").to route_to("actors#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/actors/1").to route_to("actors#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/actors/1").to route_to("actors#destroy", :id => "1")
    end

  end
end
