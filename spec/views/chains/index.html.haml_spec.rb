require 'rails_helper'

RSpec.describe "chains/index", type: :view do
  before(:each) do
    assign(:chains, [
      Chain.create!(
        :actuator => nil,
        :function => 'activate',
        :hashtag => "#hashtag1"
      ),
      Chain.create!(
        :actuator => nil,
        :function => 'activate',
        :hashtag => "#hashtag2"
      )
    ])
  end

  it "renders a list of chains" do
    render
    assert_select "tr>td", :text => 'activate', :count => 2
    assert_select "tr>td", :text => "#hashtag1".to_s, :count => 1
    assert_select "tr>td", :text => "#hashtag2".to_s, :count => 1
  end
end
