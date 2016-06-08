require 'rails_helper'

describe TextComponent, type: :model do
  context 'without a report' do
    specify { expect(build(:text_component, report: nil)).not_to be_valid }
  end

  describe '#priority' do
    it 'defaults to :medium' do
      text_component = build(:text_component)
      expect(text_component.priority).to eq "medium"
    end
  end
end
