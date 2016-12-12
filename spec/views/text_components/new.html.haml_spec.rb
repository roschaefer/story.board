require 'rails_helper'

RSpec.describe "text_components/new", type: :view do
  before(:each) do
    assign(:text_component, TextComponent.new(
      :heading => "MyString",
      :introduction => "MyText",
      :main_part => "MyText",
      :closing => "MyText",
      :from_day => 1,
      :to_day => 1
    ))
  end

  it "renders new text_component form" do
    render

    assert_select "form[action=?][method=?]", text_components_path, "post" do

      assert_select "textarea#text_component_heading[name=?]", "text_component[heading]"

      assert_select "textarea#text_component_introduction[name=?]", "text_component[introduction]"

      assert_select "textarea#text_component_main_part[name=?]", "text_component[main_part]"

      assert_select "textarea#text_component_closing[name=?]", "text_component[closing]"

      assert_select "input#text_component_from_day[name=?]", "text_component[from_day]"

      assert_select "input#text_component_to_day[name=?]", "text_component[to_day]"
    end
  end
end
