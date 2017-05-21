require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

RSpec.describe Channel, type: :model do
  describe 'factory' do
    subject { build(:channel) }
    it { is_expected.to be_valid }
  end

  describe '#name' do
    it_behaves_like 'database unique attribute', :channel, name: 'TheChannel'
  end
end
