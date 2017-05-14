require 'rails_helper'

RSpec.describe ChatfuelController, type: :controller do
  let(:valid_session) { {} }

  let(:chatbot_channel)   { Channel.chatbot }
  let(:report)            { Report.current }
  let(:topic_name)        { "milk_quality" }
  let(:topic)             { create(:topic, name: topic_name) }

  context "no text components" do
    it "returns 404" do
      get :show, params: {topic: topic_name}, session: valid_session
      expect(response.code).to eq("404")
    end
  end

  context "matching text component" do
    let(:text_component) do
      create(
        :text_component,
        report: report,
        topic: topic,
        channels: [chatbot_channel],
        main_part: "The main part"
      )
    end

    before { text_component }

    it "returns expected text" do
      get :show, params: {topic: topic_name}, session: valid_session
      expect(response.code).to eq("200")
      json_response = JSON.parse(response.body)
      expect(json_response["messages"].first["text"]).to eq("The main part")
    end
  end
end
