require 'rails_helper'

RSpec.describe "actors/index", type: :view do
  before(:each) do
    assign(:actors, [
      Actor.create!(
        :name => "Name",
        :port => 1,
        :function => "Function"
      ),
      Actor.create!(
        :name => "Name",
        :port => 1,
        :function => "Function"
      )
    ])
  end

  it "renders a list of actors" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Function".to_s, :count => 2
  end
end
