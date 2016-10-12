require 'rails_helper'

RSpec.describe "text_components/index", type: :view do
  before(:each) do
    assign(:text_components, [
      TextComponent.create!(
        :heading => "Heading",
        :introduction => "MyIntroduction",
        :main_part => "MyMainPart",
        :closing => "MyClosing",
        :from_day => 1,
        :to_day => 2
      ),
      TextComponent.create!(
        :heading => "Heading",
        :introduction => "MyIntroduction",
        :main_part => "MyMainPart",
        :closing => "MyClosing",
        :from_day => 1,
        :to_day => 2
      )
    ])
  end

  it "renders a list of text_components" do
    render
    assert_select "tr>td", :text => "Heading".to_s, :count => 2
    assert_select "tr>td", :text => "MyIntroduction".to_s, :count => 2
    assert_select "tr>td", :text => "MyMainPart".to_s, :count => 2
    assert_select "tr>td", :text => "MyClosing".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
