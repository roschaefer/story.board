require 'rails_helper'

RSpec.describe "TextComponents", type: :request do
  describe "GET /text_components" do
    it "works! (now write some real specs)" do
      get text_components_path
      expect(response).to have_http_status(200)
    end
  end
end
