require 'rails_helper'

RSpec.describe "actuators/new", type: :view do
  before(:each) do
    assign(:actuator, Actuator.new(
      :name => "MyString",
      :port => 1
    ))
  end

  it "renders new actuator form" do
    render

    assert_select "form[action=?][method=?]", actuators_path, "post" do
      assert_select "input#actuator_name[name=?]", "actuator[name]"
      assert_select "input#actuator_port[name=?]", "actuator[port]"
    end
  end
end
