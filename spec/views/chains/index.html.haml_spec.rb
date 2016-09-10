require 'rails_helper'

RSpec.describe "chains/index", type: :view do
  before(:each) do
    assign(:chains, [
      Chain.create!(
        :actuator => nil,
        :function => 'activate',
        :hashtag => "Hashtag"
      ),
      Chain.create!(
        :actuator => nil,
        :function => 'activate',
        :hashtag => "Hashtag"
      )
    ])
  end

  it "renders a list of chains" do
    render
    assert_select "tr>td", :text => 'activate', :count => 2
    assert_select "tr>td", :text => "Hashtag".to_s, :count => 2
  end
end
