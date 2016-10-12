require 'rails_helper'

RSpec.describe "text_components/edit", type: :view do
  before(:each) do
    @text_component = assign(:text_component, TextComponent.create!(
      :heading => "MyString",
      :introduction => "MyText",
      :main_part => "MyText",
      :closing => "MyText",
      :from_day => 1,
      :to_day => 1
    ))
  end

  it "renders the edit text_component form" do
    render

    assert_select "form[action=?][method=?]", text_component_path(@text_component), "post" do

      assert_select "input#text_component_heading[name=?]", "text_component[heading]"

      assert_select "textarea#text_component_introduction[name=?]", "text_component[introduction]"

      assert_select "textarea#text_component_main_part[name=?]", "text_component[main_part]"

      assert_select "textarea#text_component_closing[name=?]", "text_component[closing]"

      assert_select "input#text_component_from_day[name=?]", "text_component[from_day]"

      assert_select "input#text_component_to_day[name=?]", "text_component[to_day]"
    end
  end
end
