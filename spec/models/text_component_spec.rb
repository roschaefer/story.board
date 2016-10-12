require 'rails_helper'

RSpec.describe TextComponent, type: :model do
  describe '#heading' do
    context 'empty' do
      subject { build(:text_component, heading: '  ') }
      it { is_expected.not_to be_valid }
    end

    context '#triggers' do
      let(:text_component) { create(:text_component) }
      subject { text_component.triggers }
      it { is_expected.to be_empty }
    end
  end
end
