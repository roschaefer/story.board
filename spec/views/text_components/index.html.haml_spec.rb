require 'rails_helper'
require 'capybara/rspec'

RSpec.describe "text_components/index", type: :view do
  let(:report) { create(:report, name: 'UniqueReportName') }
  before(:each) do
    assign(:text_component, TextComponent.new)
    new_text_component = TextComponent.new
    new_text_component.triggers.build
    assign(:new_text_component, new_text_component)
    assign(:triggers, [])
    assign(:remaining_text_components, [
      TextComponent.create!(
        :heading => "Heading",
        :introduction => "MyIntroduction",
        :main_part => "MyMainPart",
        :closing => "MyClosing",
        :report_id => report.id,
        :from_day => 1,
        :to_day => 2
      ),
      TextComponent.create!(
        :heading => "Heading",
        :introduction => "MyIntroduction",
        :main_part => "MyMainPart",
        :closing => "MyClosing",
        :report_id => report.id,
        :from_day => 1,
        :to_day => 2
      )
    ])
  end


  it "does not show a duplicate submit button" do
    render
    expect(rendered).not_to include('Create Trigger')
  end

  it "shows trigger fields, e.g. the events menu" do
    render
    expect(rendered).to include('Events')
  end

  it 'will never show two seperate report input fields in one form' do
    render
    parsed = Capybara.string(rendered)
    parsed.all('form').each do |form|
      expect(form).to have_text('UniqueReportName', count: 1)
    end
  end

  it "renders a list of text_components" do
    render
    assert_select "tr>td", :text => "Heading".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
