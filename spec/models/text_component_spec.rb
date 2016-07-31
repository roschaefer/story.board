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

  let(:text_component) { create :text_component }
  describe '#active?' do
    subject { text_component.active? }
    context 'without any conditions is considered active' do
      it { is_expected.to be_truthy }
    end

    let(:sensor) { create :sensor }
    context 'with connected sensor' do
      let(:condition) { create :condition, sensor: sensor, text_component: text_component, from: 1, to: 3 }
      before { condition }

      context 'and last calibrated value in range' do
        before { create :sensor_reading, sensor: sensor, calibrated_value: 2 }
        it { is_expected.to be_truthy }
      end

      context 'and last calibrated value outside range' do
        before { create :sensor_reading, sensor: sensor, calibrated_value: 0 }
        it { is_expected.to be_falsy }
      end

      context 'with sensor readings of different intentions' do
        before do
          create :sensor_reading, sensor: sensor, calibrated_value: 0, source: :real
          create :sensor_reading, sensor: sensor, calibrated_value: 2, source: :fake
        end

        describe '#active? :real' do
          subject { text_component.active? :real }
          it { is_expected.to be_falsy }
        end
        describe '#active? :fake' do
          subject { text_component.active? :fake }
          it { is_expected.to be_truthy }
        end
      end
    end
  end
end
