require 'rails_helper'

RSpec.describe Record, type: :model do
  describe '#live?' do
    context 'saved' do
      subject { create(:record) }
      it { is_expected.not_to be_live }
    end

    context 'not saved' do
      subject { build(:record) }
      it { is_expected.to be_live }
    end
  end
end
