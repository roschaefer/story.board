require 'rails_helper'

RSpec.describe "DiaryEntries", type: :request do
  describe "GET /reports/:id/diary_entries" do
    it "works! (now write some real specs)" do
      report = Report.current
      get report_diary_entries_path(report)
      expect(response).to have_http_status(200)
    end
  end
end
