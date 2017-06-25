require 'rails_helper'

RSpec.describe DiaryEntry, type: :model do
  describe '#live?' do
    context 'saved' do
      subject { create(:diary_entry) }
      it { is_expected.not_to be_live }
    end

    context 'not saved' do
      subject { build(:diary_entry) }
      it { is_expected.to be_live }
    end
  end
end
