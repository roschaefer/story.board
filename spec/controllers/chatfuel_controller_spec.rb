require 'rails_helper'

RSpec.describe ChatfuelController, type: :controller do
  let(:valid_session) { {} }

  let(:chatbot_channel)   { Channel.chatbot }
  let(:report)            { Report.current }
  let(:topic_name)        { "milk_quality" }
  let(:topic)             { create(:topic, name: topic_name) }
  let(:params) { { topic: topic_name } }

  describe 'GET' do
    subject do
      get action, params: params, session: valid_session
      response
    end

    describe 'show' do
      let(:action) { :show }

      context "no text components" do
        it "returns 404" do
          expect(subject.code).to eq("404")
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

        it { is_expected.to have_http_status(:ok) }

        it "returns expected text" do
          json_response = JSON.parse(subject.body)
          expect(json_response["messages"].first["text"]).to eq("The main part")
        end
      end
    end
  end
end
