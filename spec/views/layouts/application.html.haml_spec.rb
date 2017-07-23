require 'rails_helper'

RSpec.describe "layouts/application", type: :view do
  let(:report) { create(:report) }

  before do
    assign(:report, report)
    assign(:report, report)
  end

  context 'the current report is not the default report' do
    before do
      expect(Report.current.id).not_to eq(report.id)
    end

    it 'link to present point to the current report' do
      render
      parsed = Capybara.string(rendered)
      expect(parsed).to have_css("a[href='/reports/present/#{report.id}']", text: 'Live-System')
    end

    it 'link and preview point to the current report' do
      render
      parsed = Capybara.string(rendered)
      expect(parsed).to have_css("a[href='/reports/preview/#{report.id}']", text: 'Preview')
    end
  end
end
