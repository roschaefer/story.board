require 'rails_helper'

RSpec.describe Chain, type: :model do
  describe '#hashtag' do
    subject { build(:chain, hashtag: nil) }
    it { is_expected.not_to be_valid }
  end

  describe '#hashtag' do
    it_behaves_like 'database unique attribute', :chain, hashtag: '#blah'
  end
end
