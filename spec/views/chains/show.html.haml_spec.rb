require 'rails_helper'

RSpec.describe "chains/show", type: :view do
  before(:each) do
    @chain = assign(:chain, Chain.create!(
      :actuator => nil,
      :function => 'activate',
      :hashtag => "Hashtag"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/activate/)
    expect(rendered).to match(/Hashtag/)
  end
end
