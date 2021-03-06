require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

RSpec.describe Event, type: :model do
  let(:event) { build(:event) }

  describe '#name' do
    it_behaves_like 'database unique attribute', :event, name: 'XYZ'

    it 'must be given' do
      expect(build(:event, name: nil)).not_to be_valid
    end
  end

  describe '#destroy' do
    it 'destroys all activations' do
      event.save
      event.activations << create_list(:event_activation, 3, event: event)
      expect{ event.destroy }.to(change{ Event::Activation.count }.from(3).to(0))
    end
  end

  describe '#active?' do
    it 'true if the last event activation is not yet finished' do
      expect{
        create(:event_activation, event: event, started_at: Time.now, ended_at: nil)
      }.to change { event.active? }.from(false).to(true)
    end
  end

  describe '#start' do
    specify { expect{ event.start }.to(change{ Event::Activation.count }.from(0).to(1)) }
    specify { expect(event.start).to be_truthy}

    context 'given a timestamp' do
      let(:timestamp) { 20.minutes.from_now }
      before { event.start(timestamp) }
      it 'creates an event activation starting at timestamp' do
        expect((Event::Activation.last.started_at - timestamp).abs).to be < 0.000001 # weird, why is it not == timestamp??
      end
    end

    context 'not ended, yet' do
      before { create(:event_activation, event: event, started_at: 10.minutes.ago, ended_at: nil) }
      specify { expect{ event.start }.not_to(change{ Event::Activation.count }) }
      specify { expect(event.start).to be_falsy}
    end
  end

  describe '#stop' do
    context 'never started before' do
      it 'does nothing' do
        expect(Event::Activation.count).to eq 0
        expect{ event.stop }.not_to(change{ Event::Activation.count })
      end

      specify { expect(event.stop).to be_falsy}
    end

    context 'not even started, yet' do
      before { create(:event_activation, event: event, started_at: 10.minutes.ago, ended_at: 5.minutes.ago) }
      specify { expect{ event.stop }.not_to(change{ Event::Activation.last.ended_at }) }
      specify { expect(event.stop).to be_falsy}
    end

    context 'when started' do
      before { create(:event_activation, event: event, started_at: 10.minutes.ago, ended_at: nil) }

      specify { expect(event.stop).to be_truthy }

      it 'sets the #ended_at of the last activation' do
        expect{ event.stop }.to(change{ Event::Activation.last.ended_at }.from(nil))
      end

      context 'given a timestamp' do
        let(:timestamp) { 20.minutes.from_now }
        before { event.stop(timestamp) }
        it 'set last event activation to timestamp' do
          expect((Event::Activation.last.ended_at - timestamp).abs).to be < 0.000001 # weird, why is it not == timestamp??
        end
      end

      context 'activations of other events' do
        let(:other_activation) { create(:event_activation, started_at: 30.minutes.ago, ended_at: 20.minutes.ago ) }
        it 'do not change' do
          other_activation
          expect { event.stop }.not_to(change{ other_activation.reload.ended_at })
        end
      end
    end
  end
end
