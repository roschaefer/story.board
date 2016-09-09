require 'rails_helper'

RSpec.describe "actors/new", type: :view do
  before(:each) do
    assign(:actor, Actor.new(
      :name => "MyString",
      :port => 1,
      :function => "MyString"
    ))
  end

  it "renders new actor form" do
    render

    assert_select "form[action=?][method=?]", actors_path, "post" do

      assert_select "input#actor_name[name=?]", "actor[name]"

      assert_select "input#actor_port[name=?]", "actor[port]"

      assert_select "input#actor_function[name=?]", "actor[function]"
    end
  end
end
