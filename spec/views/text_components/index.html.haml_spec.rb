require 'rails_helper'
require 'capybara/rspec'

RSpec.describe "text_components/index", type: :view do
  let(:report) { create(:report, name: 'UniqueReportName') }
  let(:text_components) do
    [create(
        :text_component,
        :heading => "Heading",
        :report_id => report.id,
        :publication_status => 0,
        :from_day => 1,
        :to_day => 2
      ),
      create(
        :text_component,
        :heading => "Heading",
        :report_id => report.id,
        :publication_status => 2,
        :from_day => 1,
        :to_day => 2
      )]
  end

  before(:each) do
    assign(:text_component, TextComponent.new)
    new_text_component = TextComponent.new
    new_text_component.triggers.build
    assign(:new_text_component, new_text_component)
    assign(:triggers, [])
    assign(:sensors, [
      create(
        :sensor,
        :name => "Sensor Name",
      )
    ])
    assign(:events, [
      create(
        :event,
        :name => "Event Name",
      )
    ])
    assign(:filter, {})
    assign(:text_components, text_components)
    assign(:text_components_without_triggers, text_components)
    assign(:trigger_groups, [])
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
      expect(form).to have_selector('.text-editor__toolbar__item.dropdown-toggle', :count => 2)
    end
  end

  it 'will never show two seperate report input fields in one form' do
    render
    parsed = Capybara.string(rendered)
    expect(parsed).to have_css('form.edit_text_component')
    parsed.all('form.edit_text_component').each do |form|
      expect(form).to have_text('UniqueReportName', count: 1)
    end
  end

  it "renders a list of text_components" do
    render
    assert_select "tr>td", :text => "Heading".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "draft", :count => 1
    assert_select "tr>td", :text => "published", :count => 1
  end
end
