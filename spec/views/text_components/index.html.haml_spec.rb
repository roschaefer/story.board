require 'rails_helper'

RSpec.describe "text_components/index", type: :view do
  let(:report) { create(:report) }
  before(:each) do
    assign(:text_components, [
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

  it "renders a list of text_components" do
    render
    assert_select "tr>td", :text => "Heading".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
