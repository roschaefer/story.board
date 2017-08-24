require 'rails_helper'

RSpec.describe "Actuators", type: :request do
  describe "GET /actuators" do
    it "works! (now write some real specs)" do
      get actuators_path
      expect(response).to have_http_status(302)
    end
  end
end
