require 'rails_helper'

RSpec.describe "chains/show", type: :view do
  before(:each) do
    @chain = assign(:chain, Chain.create!(
      :actuator => nil,
      :function => 1,
      :hashtag => "Hashtag"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Hashtag/)
  end
end
