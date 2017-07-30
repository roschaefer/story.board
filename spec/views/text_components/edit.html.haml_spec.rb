require 'rails_helper'

RSpec.describe "text_components/edit", type: :view do
  let(:report) { Report.current }
  before(:each) do
    @report = report
    @sensors, @events = [], []
    @text_component = assign(:text_component, create(:text_component))
  end

  it "renders the edit text_component form" do
    render

    assert_select "form[action=?][method=?]", report_text_component_path(report, @text_component), "post" do
    end
  end

  it "does not show a duplicate submit button" do
    render
    expect(rendered).not_to include('Create Trigger')
  end

  it "shows trigger fields, e.g. the events menu" do
    render
    expect(rendered).to include('Events')
  end

  it "contains dropdown menus for sensors and events to insert markup into textareas" do
    render
    parsed = Capybara.string(rendered)
    expect(parsed).to have_css('form.edit_text_component')
    parsed.all('form.edit_text_component').each do |form|
      expect(form).to have_selector('.text-editor__toolbar__item select', :count => 2)
    end
  end

  context 'another report' do
    let(:report) { create(:report, name: 'UniqueReportName') }
    it 'will never show two seperate report input fields in one form' do
      render
      parsed = Capybara.string(rendered)
      expect(parsed).to have_css('form.edit_text_component')
      parsed.all('form.edit_text_component').each do |form|
        expect(form).to have_text('UniqueReportName', count: 1)
      end
    end
  end
end
