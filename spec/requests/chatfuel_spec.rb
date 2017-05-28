require 'rails_helper'

RSpec.describe "Chatfuel", type: :request do
  describe 'GET' do
    subject do
      get url
      response
    end

    describe "/chatfuel/text_components/:text_component_id/answer_to_question/:index" do
      let(:text_component_id) { 1 }
      let(:index) { 1 }
      let(:url) { "/chatfuel/text_components/#{text_component_id}/answer_to_question/#{index}" }

      describe 'bogus params' do
        describe 'bogus index' do
          before { create(:text_component, id: 1) }
          let(:index) { 'blah' }
          it { is_expected.to have_http_status(:not_found) }
        end

        describe 'no text_component_id' do
          let(:text_component_id) { 'blah' }
          it 'raise ActiveRecord::RecordNotFound' do
            expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end


      context 'no text component' do
        it 'raise ActiveRecord::RecordNotFound' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'text component without question_answer' do
        before { create(:text_component, id: 1) }
        it { is_expected.to have_http_status(:not_found) }
      end

      context 'text component with one question_answer and without topic' do
        let(:question_answer) { create(:question_answer, question: 'What up?', answer: 'The sun') }
        before { create(:text_component, id: 1, question_answers: [question_answer], topic: nil) }
        it { is_expected.to have_http_status(404) }
      end

      context 'text component with just one question_answer' do
        let(:topic) { create(:topic, id: 1, name: "milk_quality") }
        let(:question_answer) { create(:question_answer, question: 'What up?', answer: 'The sun') }
        before { create(:text_component, id: 1, question_answers: [question_answer], topic: topic) }

        it { is_expected.to have_http_status(:ok) }

        it 'reveals the answer to the question' do
          json_response = JSON.parse(subject.body)
          expect(json_response['messages'][0]['attachment']['payload']['text']).to eq 'The sun'
        end
      end

      context 'text component with two question_answers' do
        let(:topic) { create(:topic, id: 1, name: "milk_quality") }
        let(:question_answers) { create_list(:question_answer, 2, question: 'What up?', answer: 'The sun') }
        before { create(:text_component, id: 1, question_answers: question_answers, topic: topic) }

        it 'reveals the answer to the question' do
          json_response = JSON.parse(subject.body)
          expect(json_response['messages'][0]['attachment']['payload']['text']).to eq 'The sun'
        end

        it 'shows a button attachment' do
          json_response = JSON.parse(subject.body)
          expect(json_response['messages'][0]['attachment']['payload']['template_type']).to eq 'button'
        end

        describe 'index == 2' do
          let(:index) { 2 }

          it 'reveals last answer to the question' do
            json_response = JSON.parse(subject.body)
            expect(json_response['messages'][0]['attachment']['payload']['text']).to eq 'The sun'
          end
        end
      end
    end
  end
end
