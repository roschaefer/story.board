require 'rails_helper'

RSpec.describe TextComponent, type: :model do
  describe '#destroy' do
    it 'destroys #question_answers' do
      text_component = create(:text_component)
      question_answers = create_list(:question_answer, 3, text_component: text_component)
      expect{ text_component.destroy}.to change{ QuestionAnswer.count }.from(3).to(0)
    end
  end

  describe '#question_answers' do
    it 'accepts nested attributes' do
      text_component = build(:text_component, question_answers_attributes: [attributes_for(:question_answer)])
      expect{ text_component.save }.to change{ QuestionAnswer.count }.from(0).to(1)
    end
  end

  describe '#displayed_time_frame' do
    subject { text_component.displayed_timeframe }

    context 'timeframe == [6,9]' do
      let(:text_component) { build(:text_component, from_hour: 6, to_hour: 9) }
      it { is_expected.to eq('in the morning') }
    end

    context 'timeframe == nil' do
      let(:text_component) { build(:text_component, from_hour: nil, to_hour: nil) }
      it { is_expected.to eq('always') }
    end

    context 'timeframe mismatch' do
      let(:text_component) { build(:text_component, from_hour: 1, to_hour: nil) }
      it { is_expected.to eq(nil) }
    end
  end

  describe '#create' do
    let(:report) { create(:report) }
    subject { create(:text_component, report: report) }

    it "has a channel assigned" do
      expect(subject.channels).not_to be_empty
    end
  end

  describe 'to_hour' do
    subject { text_component }
    let(:text_component) { build(:text_component, attributes) }
    let(:attributes) { {to_hour: 3 } }
    context 'without #from_hour' do
      it { is_expected.not_to be_valid }
    end
  end

  describe 'from_hour' do
    subject { text_component }
    let(:text_component) { build(:text_component, attributes) }
    let(:attributes) { { from_hour: 3 } }
    context 'without #to_hour' do
      it { is_expected.not_to be_valid }
    end

    context 'given along with #to_hour' do
      let(:attributes) { super().merge({ to_hour: 3 }) }
      it { is_expected.to be_valid }

      context 'below 0' do
        let(:attributes) { super().merge({ from_hour: -1 }) }
        it { is_expected.not_to be_valid }
      end

      context 'above 23' do
        let(:attributes) { super().merge({ from_hour: 24 }) }
        it { is_expected.not_to be_valid }
      end
    end
  end

  describe '#heading' do
    context 'empty' do
      subject { build(:text_component, heading: '  ') }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#report' do
    context 'missing' do
      subject { build(:text_component, report: nil) }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#triggers' do
    let(:text_component) { create(:text_component) }
    subject { text_component.triggers }
    it { is_expected.to be_empty }
  end

  describe '#active?' do
    let(:diary_entry) { DiaryEntry.new }
    let(:text_component) { create(:text_component) }
    subject { text_component.active?(diary_entry) }

    context 'triggers empty' do
      it { is_expected.to be true }
    end

    context 'given one trigger' do
      context 'active trigger' do
        let(:text_component) { create(:text_component, triggers: [create(:trigger, :active)]) }
        it { is_expected.to be true }
      end

      context 'inactive trigger' do
        let(:text_component) { create(:text_component, triggers: [create(:trigger, :inactive)]) }
        it { is_expected.to be false }
      end
    end

    context 'given many triggers' do
      let(:text_component) { create(:text_component, triggers: triggers) }

      context 'some are active, some are inactive' do
        let(:triggers) { [create(:trigger, :inactive), create(:trigger, :active)] }
        it { is_expected.to be false }
      end

      context 'all active' do
        let(:triggers) { create_list(:trigger, 2, :active) }
        it { is_expected.to be true }
      end
    end
  end

  describe '#timeframe=' do
    let(:text_component) { build(:text_component) }
    it 'sets #from_hour' do
      expect{ text_component.timeframe = '[18, 23]' }.to(change{ text_component.from_hour }.from(nil).to(18))
    end
    it 'sets #to_hour' do
      expect{ text_component.timeframe = '[18, 23]' }.to(change{ text_component.to_hour }.from(nil).to(23))
    end
  end

  describe '#timeframe' do
    let(:text_component) { build(:text_component, from_hour: 13, to_hour: 17) }
    subject { text_component.timeframe }
    it { is_expected.to eq '[13,17]' }
  end

  describe '#priority' do
    let(:text_component) { create(:text_component) }
    subject { text_component.priority }

    context 'empty triggers' do
      it { is_expected.to be nil }
    end

    context 'many triggers with different priorities' do
      before do
        create(:trigger, text_components: [text_component], priority: :medium)
        create(:trigger, text_components: [text_component], priority: :high)
        create(:trigger, text_components: [text_component], priority: :always_on_top)
      end

      it 'is the highest priority' do
        is_expected.to eq 'always_on_top'
      end
    end
  end
end
