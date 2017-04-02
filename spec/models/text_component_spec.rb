require 'rails_helper'

RSpec.describe TextComponent, type: :model do
  describe '#question_answers' do
    it 'accepts nested attributes' do
      text_component = build(:text_component, question_answers_attributes: [attributes_for(:question_answer)])
      expect{ text_component.save }.to change{ QuestionAnswer.count }.from(0).to(1)
    end
  end

  describe '#create' do
    let(:report) { create(:report) }
    let!(:default_channel) { create(:channel, name: "sensorstory", report: report) }
    subject { create(:text_component, report: report) }

    it "has a channel assigned" do
      expect(subject.channels).not_to be_empty
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
    let(:text_component) { create(:text_component) }
    subject { text_component.active? }
    context 'triggers empty' do
      it { is_expected.to be true }

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
        context'some are active, some are inactive' do
          let(:triggers) { [create(:trigger, :inactive), create(:trigger, :active)] }
          it { is_expected.to be false }
        end
        context'all active' do
          let(:triggers) { create_list(:trigger, 2, :active) }
          it { is_expected.to be true }
        end
      end
    end
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
      end

      it 'is the highest priority' do
        is_expected.to eq 'high'
      end
    end
  end
end
