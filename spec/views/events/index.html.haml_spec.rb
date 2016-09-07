require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    assign(:events, [
      create(:event, name: 'Foo'),
      create(:event, name: 'Bar')
    ])
  end

  it "renders a list of events" do
    render
  end
end
