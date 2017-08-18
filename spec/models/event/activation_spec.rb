require 'rails_helper'

RSpec.describe Event::Activation, type: :model do
  describe '::active' do
    let(:time) { Time.now }
    let(:activation) { create(:event_activation, started_at: started_at, ended_at: ended_at) }
    before { activation }
    subject { described_class.active(time) }

    context 'activation started before given time' do
      let(:started_at) { time - 2.minutes }

      context 'activation ended after given time' do
        let(:ended_at) { time + 3.minutes }
        it { is_expected.to include(activation) }
      end

      context 'activation ended before given time' do
        let(:ended_at) { time - 1.minute }
        it { is_expected.to be_empty }
      end
      context 'activation never ended' do 
        let(:ended_at) { nil }
        it { is_expected.to include(activation) }
      end
    end

    context 'activation started after given time' do
      let(:started_at) { time + 2.minutes }
      context 'activation ended after given time' do
        let(:ended_at) { time + 3.minutes }
        it { is_expected.to be_empty }
      end
      context 'activation never ended' do
        let(:ended_at) { nil }
        it { is_expected.to be_empty }
      end
    end
  end

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

    describe 'overlaps' do
        let(:event) { create(:event) }
        let(:overlapping_activation){ create(:event_activation, event: event, started_at: 10.minutes.ago,  ended_at: 10.minutes.from_now) }
        subject { build(:event_activation, event: event, started_at: Time.now, ended_at: nil )}
        before { overlapping_activation }
        it { is_expected.not_to be_valid }

        describe 'with activations of a totally different event' do
            before { overlapping_activation.update(event: create(:event)) }
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
