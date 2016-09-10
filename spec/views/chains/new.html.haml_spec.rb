require 'rails_helper'

RSpec.describe "chains/new", type: :view do
  before(:each) do
    assign(:chain, Chain.new(
      :actuator => nil,
      :function => 1,
      :hashtag => "MyString"
    ))
  end

  it "renders new chain form" do
    render

    assert_select "form[action=?][method=?]", chains_path, "post" do

      assert_select "input#chain_actuator_id[name=?]", "chain[actuator_id]"

      assert_select "input#chain_function[name=?]", "chain[function]"

      assert_select "input#chain_hashtag[name=?]", "chain[hashtag]"
    end
  end
end
