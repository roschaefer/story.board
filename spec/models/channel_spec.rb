require 'rails_helper'

RSpec.describe Channel, type: :model do
  describe 'factory' do
    subject { build(:channel) }
    it { is_expected.to be_valid }
  end

  describe 'channel without report' do
    subject { build(:channel, report: nil) }
    it { is_expected.not_to be_valid }
  end
end
