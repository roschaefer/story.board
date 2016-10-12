require 'rails_helper'

RSpec.describe TextComponent, type: :model do
  describe '#heading' do
    context 'empty' do
      subject { build(:text_component, heading: '  ') }
      it { is_expected.not_to be_valid }
    end
  end
end
