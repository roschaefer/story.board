require 'rails_helper'

RSpec.describe "Generate Fake Sample Data", type: :request do

  describe "POST /sensor_readings/fake" do
    let(:sample_params) {{:sensor_id => sensor.id, :quantity => 3, :from => 1, :to =>2}}
    let(:sensor) { create(:sensor) }
    let(:headers) { { "ACCEPT" => "application/json"      } }
    let(:url) { "/sensor_readings/fake" }


    it "generates sample data for a sensor" do
      expect {post url, {:sample => sample_params}, headers }.to change{Sensor::Reading.count}.from(0).to(3)
    end

    it "requires sensor_id" do
      post url, {:sample => sample_params.merge(:sensor_id => nil)}, headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "requires upper and lower bounds" do
      post url, {:sample => sample_params.merge(:to => nil)}, headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "lower bound must smaller than upper bound" do
      post url, {:sample => sample_params.merge(:from => 4, :to => 3)}, headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns generated sensor readings as json" do
      post url, :sample => sample_params, :format => :json
      expect(JSON.parse(response.body).size).to eq 3
    end
  end
end
