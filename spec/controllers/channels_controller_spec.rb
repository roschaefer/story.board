require 'rails_helper'

RSpec.describe ChannelsController, type: :controller do
  login_user

  let(:valid_session) { {} }

  describe "GET #show" do
    it "returns http success" do
      get :show, params: {:id => 1}, session: valid_session, format: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    let(:channel) { Channel.sensorstory }

    it 'renders correct template' do
      get :edit, params: {id: channel.id}, session: valid_session
      expect(response).to render_template :edit
    end

    it 'assigns expected channel' do
      get :edit, params: {id: channel.id}, session: valid_session
      expect(assigns(:channel)).to eq channel
    end
  end
end
