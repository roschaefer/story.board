require 'rails_helper'

RSpec.describe Chain, type: :model do
  describe '#hashtag' do
    subject { build(:chain, hashtag: nil) }
    it { is_expected.not_to be_valid }
  end

  describe '#hashtag' do
    it_behaves_like 'database unique attribute', :chain, hashtag: '#blah'
  end

  describe '#actuator_name' do
    subject { chain.actuator_name }
    context 'actuator missing' do
      let(:chain) { create(:chain, actuator: nil) }
      it { is_expected.to be_nil }
    end

    context 'actuator present' do
      let(:actuator) { create(:actuator) }
      let(:chain) { create(:chain, actuator: actuator) }
      it { is_expected.to eq actuator.name }
    end
  end

end
