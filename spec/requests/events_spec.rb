require 'rails_helper'

RSpec.describe "Events", type: :request do
  let(:event) { create(:event) }

  describe 'format: :json' do
    describe 'GET /events/:id' do
      let(:action) { get event_path(event), params: { format: :json } }
      it 'contains activations' do
        create(:event_activation, event: event, id: 4711)
        action
        js = JSON.parse(response.body)
        expect(js['activations'][0]['id']).to eq 4711
      end
    end

    describe 'when signed in' do
      let(:user) { create(:user) }
      before { sign_in user }

      describe 'POST /events/:id/start' do
        let(:action) { post start_event_path(event), params: { format: :json } }

        it 'starts the event' do
          expect { action }.to(change { event.active? }.from(false).to(true))
        end

        describe 'when started already' do
          before { event.start }
          it 'renders error message' do
            action
            expect(JSON.parse(response.body)).to include({'error' => 'Event is already in this state'})
          end
        end
      end

      describe 'POST /events/:id/stop' do
        before { event.start }
        let(:action) { post stop_event_path(event), params: { format: :json } }
        it 'stops the event' do
          expect { action }.to(change { event.active? }.from(true).to(false))
        end
      end
    end
  end
end

