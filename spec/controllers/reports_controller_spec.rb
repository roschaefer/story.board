require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  login_user

  describe 'GET #current' do
    it 'redirects to current report' do
      expect(Report.current.id).to eq 1
      get :current
      expect(response).to redirect_to '/reports/present/1'
    end

    context 'no reports' do
      it 'renders a replacement template' do
        Report.destroy_all
        get :current
        expect(response).to render_template :no_reports
      end
    end
  end

  describe 'GET #present' do
    it "renders template 'present'" do
      expect(Report.current.id).to eq 1
      get :present, params: {id: 1}
      expect(response).to render_template :present
    end
  end
end
