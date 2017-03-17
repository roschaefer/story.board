require 'rails_helper'

RSpec.describe ChatfuelController, type: :controller do
  let(:valid_session) { {} }

  let!(:chatbot_channel)   { create :channel, report: report, name: "chatbot" }
  let(:report)            { create(:report) }
  let(:topic_name)        { "milk_quality" }
  let(:topic)             { create(:topic, name: topic_name) }

  context "no text components" do
    it "returns 404" do
      get :show, params: {topic: topic_name}, session: valid_session
      expect(response.code).to eq("404")
    end
  end

  context "matching text component" do
    let(:main_part) { "Main Part" }
    let!(:text_component) do
      create(
        :text_component,
        report: report,
        topic: topic,
        channels: [chatbot_channel],
        triggers: [create(:trigger, priority: "high")],
        main_part: main_part
      )
    end

    it "returns expected text" do
      get :show, params: {topic: topic_name}, session: valid_session
      expect(response.code).to eq("200")
      response = assigns(:response)
      expect(response[:messages].first[:text]).to eq(main_part)
    end
  end
end
