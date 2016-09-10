require 'rails_helper'

RSpec.describe "actuators/edit", type: :view do
  before(:each) do
    @actor = assign(:actuator, Actuator.create!(
      :name => "MyString",
      :port => 1
    ))
  end

  it "renders the edit actuator form" do
    render

    assert_select "form[action=?][method=?]", actuator_path(@actor), "post" do
      assert_select "input#actuator_name[name=?]", "actuator[name]"
      assert_select "input#actuator_port[name=?]", "actuator[port]"
    end
  end
end
