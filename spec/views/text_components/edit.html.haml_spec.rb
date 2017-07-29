require 'rails_helper'

RSpec.describe "text_components/edit", type: :view do
  before(:each) do
    @text_component = assign(:text_component, TextComponent.create!())
  end

  it "renders the edit text_component form" do
    render

    assert_select "form[action=?][method=?]", text_component_path(@text_component), "post" do
    end
  end
end
