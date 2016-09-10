require 'rails_helper'

RSpec.describe "actuators/index", type: :view do
  before(:each) do
    assign(:actuators, [
      Actuator.create!(
        :port => 1,
        :name => "Name1"
      ),
      Actuator.create!(
        :name => "Name2",
        :port => 1
      )
    ])
  end

  it "renders a list of actuators" do
    render
    assert_select "tr>td", :text => "Name1".to_s, :count => 1
    assert_select "tr>td", :text => "Name2".to_s, :count => 1
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
