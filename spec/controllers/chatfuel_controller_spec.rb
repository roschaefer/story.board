require 'rails_helper'

RSpec.describe ChatfuelController, type: :controller do
  let(:valid_session) { {} }

  let(:chatbot_channel)   { Channel.chatbot }
  let(:report)            { Report.current }
  let(:topic_name)        { "milk_quality" }
  let(:topic)             { create(:topic, name: topic_name) }
  let(:params) { { report_id: report.id, topic: topic_name } }

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

        context "without markup" do
          before { create(:text_component, report: report, topic: topic, channels: [chatbot_channel], main_part: "The main part") }

          it { is_expected.to have_http_status(:ok) }

          it "returns expected text" do
            json_response = JSON.parse(subject.body)
            expect(json_response["messages"].first["text"]).to eq("The main part")
          end
        end

        context "with markup and sensory data" do
          let(:sensor)        { create(:sensor, name: 'SensorXY', sensor_type: sensor_type) }
          let(:sensor_type)   { create(:sensor_type, property: 'Temperature', unit: '°C') }

          before do
            create(:text_component, report: report, topic: topic, channels: [chatbot_channel], main_part: "SensorXY: { value(#{sensor.id}) }")
            create(:sensor_reading, sensor: sensor, calibrated_value: 5)
          end

          it { is_expected.to have_http_status(:ok) }

          it "returns text with replaced markup" do
            json_response = JSON.parse(subject.body)
            expect(json_response["messages"].first["text"]).to eq("SensorXY: 5.0 °C")
          end
        end

      end
    end
  end
end
