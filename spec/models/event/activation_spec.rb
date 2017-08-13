require 'rails_helper'

RSpec.describe Event::Activation, type: :model do
  describe '#event' do
    context 'missing' do
      subject { build(:event_activation, event: nil) }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#started_at' do
    context 'missing' do
      subject { build(:event_activation, started_at: nil) }
      it { is_expected.not_to be_valid }
    end

    context 'before last #ended_at' do
      before { create(:event_activation, started_at: last_started_at,  ended_at: last_ended_at) }
      let(:last_started_at) { 10.minutes.ago }
      let(:last_ended_at) { last_started_at + 5.minutes }

      subject { build(:event_activation, started_at: (last_ended_at - 20.minutes) ) }
      it { is_expected.not_to be_valid }

      context 'but when #ended_at also ends before another activation' do
        subject { build(:event_activation, started_at: (last_ended_at - 20.minutes), ended_at: (last_ended_at - 10.minutes) ) }
        it { is_expected.to be_valid }
      end
    end
  end

  describe '#ended_at' do
    context 'before #started_at' do
      subject { build(:event_activation, started_at: Time.now, ended_at: 10.minutes.ago ) }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#duration' do
    subject { activation.duration }
    let(:timestamp) { 2.minutes.ago }
    let(:activation) { build(:event_activation, started_at: timestamp, ended_at: (timestamp + 10.minutes) ) }
    it 'returns the time span between #started_at and #ended_at' do
      expect(subject).to eq(10.minutes)
    end

    context 'not completed yet' do
      let(:activation) { build(:event_activation, started_at: Time.now, ended_at: nil ) }
      it { is_expected.to be_nil }
    end
  end
end
