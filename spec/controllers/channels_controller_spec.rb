require 'rails_helper'

RSpec.describe ChannelsController, type: :controller do
  let(:valid_session) { {} }

  describe "GET #show" do
    it "returns http success" do
      get :show, params: {report_id: 1, :id => 1}, session: valid_session, format: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    let(:report) { create(:report) }
    let!(:channel) { create(:channel, name: "sensorstory", report: report) }

    it 'renders correct template' do
      get :edit, params: {id: channel.id, report_id: report.id}, session: valid_session
      expect(response).to render_template :edit
    end

    it 'assigns expected channel' do
      get :edit, params: {id: channel.id, report_id: report.id}, session: valid_session
      expect(assigns(:channel)).to eq channel
    end
  end
end
