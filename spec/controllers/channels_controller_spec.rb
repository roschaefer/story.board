require 'rails_helper'

RSpec.describe ChannelsController, type: :controller do
  let(:valid_session) { {} }

  describe "GET #show" do
    it "returns http success" do
      get :show, params: {:id => 1}, session: valid_session, format: :json
      expect(response).to have_http_status(:success)
    end
  end

end
