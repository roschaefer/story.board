require 'rails_helper'

RSpec.describe "Chains", type: :request do
  describe "GET /chains" do
    it "works! (now write some final specs)" do
      get chains_path
      expect(response).to have_http_status(302)
    end
  end
end
