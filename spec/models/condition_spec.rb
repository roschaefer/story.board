require 'rails_helper'

RSpec.describe Condition, type: :model do
  subject { build(:condition) }
  it { is_expected.to be_valid }

  describe '#sensor' do
    context 'missing' do
      subject { build(:condition, sensor: nil) }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#trigger' do
    context 'missing' do
      subject { build(:condition, trigger: nil) }
      it { is_expected.not_to be_valid }
    end
  end
end
