require 'rails_helper'

RSpec.describe "diary_entries/show", type: :view do
  before(:each) do
    report = create(:report, name: "I am a super cool report")
    assign(:report, report)
    @diary_entry = assign(:diary_entry, create(:diary_entry, release: :final, report: report))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/final/)
    expect(rendered).to match(/I am a super cool report/)
  end
end
