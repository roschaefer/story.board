require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:sensorstory_channel)  { create(:channel, name: "sensorstory") }

  describe 'GET #current' do
    it 'redirects to current report' do
      create(:report, id: 1, channels: [sensorstory_channel])
      get :current
      expect(response).to redirect_to '/reports/present/1'
    end

    context 'no reports' do
      it 'renders a replacement template' do
        get :current
        expect(response).to render_template :no_reports
      end
    end
  end

  describe 'GET #present' do
    it "renders template 'present'" do
      create(:report, id: 1, channels: [sensorstory_channel])
      get :present, params: {id: 1}
      expect(response).to render_template :present
    end
  end
end
