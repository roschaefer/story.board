require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:report) { create(:report) }
  context 'given a report' do
    before { report }
    specify { expect(Report.current).to eql report }
  end

  describe '#destroy' do
    let(:variables) { {a: 1, b: 2, c: 3}.collect {|k,v| create(:variable, key: k, value: v)} }
    let (:report) { create(:report, variables: variables) }
    it 'destroys dependent variables' do
      report
      expect { report.destroy }.to change { Variable.count }.from(3).to(0)
    end
  end
  describe '#archive!' do
    subject { report.archive! }
    it 'stores a new record' do
     expect{ subject } .to change{ Record.count }.from(0).to(1)
    end

    it 'adds a new record to the report' do
     expect{ subject; report.reload }.to change{ report.records.size }.from(0).to(1)
    end

    context 'for :fake data' do
      subject { report.archive!(intention: :fake) }
      it 'stores the intention along with the record' do
        subject
        expect(report.records.first.intention).to eq 'fake'
      end
    end

    context 'when maximum limit is reached' do
      before { Record::LIMIT.times { report.archive! } }
      it 'number of records stay the same' do
        expect{ subject }.not_to change{ report.records.size }
      end

      it 'can exceed for another intention' do
        expect{ report.archive!(intention: :fake) }.to change{ report.records.size }
      end
    end
  end

  describe '#compose' do
    subject { report.compose }
    it 'returns a record' do
      is_expected.to be_kind_of Record
    end
  end

  describe '#active_triggers' do
    subject { report.active_triggers }
    let(:sensor)          { create :sensor }
    it { is_expected.to be_empty }

    context 'given a trigger connected to a sensor via a certain condition' do
      let(:trigger) { create :trigger, report: report }
      before do
        create(:condition, sensor: sensor, trigger: trigger, from: 1, to: 3)
      end

      context 'for sensor readings with a certain intent' do
        before do
          create(:sensor_reading, sensor: sensor, intention: :fake, calibrated_value: 2)
          create(:sensor_reading, sensor: sensor, intention: :real, calibrated_value: 0)
        end

        describe '#active_triggers :real' do
          subject { report.active_triggers intention: :real }
          it { is_expected.not_to include trigger }
        end
        describe '#active_triggers :fake' do
          subject { report.active_triggers intention: :fake }
          it { is_expected.to include trigger }
        end
      end
    end

    context 'sensor reading value is upper boundary and lower boundary' do
      let(:lower) { create(:trigger, report: report, heading: 'Lower') }
      let(:upper) { create(:trigger, report: report, heading: 'Upper') }
      before do
        create(:sensor_reading, sensor: sensor, calibrated_value: 10)
        create(:condition, trigger: lower, sensor: sensor, from: 0, to: 10)
        create(:condition, trigger: upper, sensor: sensor, from: 10, to: 20)
      end

      it 'contains only one trigger - the upper trigger' do
        expect(subject).to contain_exactly(upper)
      end
    end
  end
end
