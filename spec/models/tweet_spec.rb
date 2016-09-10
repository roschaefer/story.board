require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe '#user' do
    subject { build(:tweet, user: nil) }
    it { is_expected.not_to be_valid }

    describe '#before_create' do
      let(:chain) { create(:chain, hashtag: 'hashtag') }
      let(:chain2) { create(:chain, hashtag: 'another') }
      it 'auto-assigns the correct chain' do
        chain; chain2 # create chains
        tweet = Tweet.new(user: '@somebody', message: 'it is about #hashtag')
        tweet.save!
        expect(tweet.chain).to eq chain
      end

      it 'assigns the first matching chain' do
        chain; chain2 # create chains
        tweet = Tweet.new(user: '@somebody', message: 'it is about #another #hashtag')
        tweet.save!
        expect(tweet.chain).to eq chain2
      end
    end

    describe '#after_create' do
      let(:actuator) { create(:actuator) }
      let(:chain) { create(:chain, actuator: actuator) }
      it 'creates a command' do
        tweet = build(:tweet, chain: chain)
        expect { tweet.save }.to change { Command.count }.from(0).to(1)
      end

      it 'created command belongs to the tweet' do
        tweet = build(:tweet, chain: chain)
        tweet.save
        expect(tweet.command).not_to be_nil
      end

      it 'created command has the same function' do
        tweet = create(:tweet, chain: chain)
        expect(Command.last.function).to eq tweet.function
      end

      it 'created command is pending' do
        create(:tweet, chain: chain)
        expect(Command.last).to be_pending
      end
    end
  end
end
