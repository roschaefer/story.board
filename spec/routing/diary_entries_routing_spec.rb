require "rails_helper"

RSpec.describe DiaryEntriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/reports/42/diary_entries").to route_to("diary_entries#index", report_id: "42")
    end

    it "routes to #show" do
      expect(:get => "/reports/3/diary_entries/1").to route_to("diary_entries#show", report_id: "3", id: "1")
    end
  end
end
