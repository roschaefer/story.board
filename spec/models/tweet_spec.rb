require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe '#user' do
    subject { build(:tweet, user: nil) }
    it { is_expected.not_to be_valid }
  end
end
