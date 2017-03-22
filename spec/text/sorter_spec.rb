require 'rails_helper'

RSpec.describe Text::Sorter do
  describe '#sort' do
    subject { described_class }
    let(:opts) { {} }

    context 'several text components with different priorities' do
      let(:expected_result) { text_components }

      let(:text_components) do
        [
          create(:text_component, heading: 'Text component High', triggers: [create(:trigger, priority: :high)]),
          create(:text_component, heading: 'Text component Medium', triggers: [create(:trigger, priority: :medium)]),
          create(:text_component, heading: 'Text component Low', triggers: [create(:trigger, priority: :low)]),
        ]
      end

      it 'returns components ordered by priority' do
        expect(subject.sort(text_components, opts)).to eq(expected_result)
      end
    end

    context 'given text_components without triggers' do
      let(:expected_result) { text_components.reverse }

      let(:text_components) do
        [
          create(:text_component, heading: 'Text component 2', triggers: []),
          create(:text_component, heading: 'Text component 1', triggers: [create(:trigger, priority: :medium)]),
        ]
      end

      it 'returns text sorted by trigger' do
        expect(subject.sort(text_components, opts)).to eq(expected_result)
      end
    end
  end
end
