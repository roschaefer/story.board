require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:report) { create(:report) }
  context 'given a report' do
    before { report }
    specify { expect(Report.current).to eql report }
  end


  describe '#active_text_components' do
    subject { report.active_text_components }
    it { is_expected.to be_empty }

    context 'given a text component connected to a sensor via a certain condition' do
      let(:text_component) { create :text_component, report: report }
      let(:sensor)          { create :sensor }
      before do
        create(:condition, sensor: sensor, text_component: text_component, from: 1, to: 3)
      end

      context 'for sensor readings with a certain intent' do
        before do
          create(:sensor_reading, sensor: sensor, intention: :fake, calibrated_value: 2)
          create(:sensor_reading, sensor: sensor, intention: :real, calibrated_value: 0)
        end

        describe '#active_text_components :real' do
          subject { report.active_text_components :real }
          it { is_expected.not_to include text_component }
        end
        describe '#active_text_components :fake' do
          subject { report.active_text_components :fake }
          it { is_expected.to include text_component }
        end
      end
    end
  end
end
