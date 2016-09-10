require 'rails_helper'

RSpec.describe "actuators/show", type: :view do
  before(:each) do
    @actuator = assign(:actuator, Actuator.create!(
      :name => "Name",
      :port => 1,
      :function => "Function"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Function/)
  end
end
