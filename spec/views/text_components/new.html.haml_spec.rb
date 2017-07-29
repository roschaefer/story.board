require 'rails_helper'

RSpec.describe "text_components/new", type: :view do
  before(:each) do
    assign(:text_component, TextComponent.new())
  end

  it "renders new text_component form" do
    render

    assert_select "form[action=?][method=?]", text_components_path, "post" do
    end
  end
end
