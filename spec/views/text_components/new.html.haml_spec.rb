require 'rails_helper'

RSpec.describe "text_components/new", type: :view do
  let(:report) { create(:report) }
  before(:each) do
    assign(:report, report)
    assign(:sensors, [])
    assign(:events, [])
    assign(:text_component, TextComponent.new())
  end

  it "renders new text_component form" do
    render

    assert_select "form[action=?][method=?]", report_text_components_path(report), "post" do
    end
  end
end
