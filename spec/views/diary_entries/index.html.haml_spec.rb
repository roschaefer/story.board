require 'rails_helper'

RSpec.describe "diary_entries/index", type: :view do
  before(:each) do
    report = create(:report, name: "I am a super cool report")
    assign(:report, report)
    assign(:diary_entries, create_list(:diary_entry, 2, report: report, release: :debug))
  end

  it "renders a list of diary_entries" do
    render
    assert_select "tr>td", :text => "debug", :count => 2
    assert_select "tr>td", :text => "I am a super cool report", :count => 2
  end
end
