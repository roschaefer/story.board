require 'rails_helper'

describe Trigger, type: :model do
  let(:trigger) { create :trigger }
  let(:sensor) { create(:sensor) }

  context 'given a sensor reading' do
    subject { create(:trigger, :with_a_sensor_reading, params) }
    describe '#validity_period' do
      let(:params) { { validity_period: 3 } }
      it { is_expected.to be_active }
      context 'some hours later' do
        it 'no longer relevant' do
          expect(subject).to be_active
          Timecop.travel(4.hours.from_now) do
            expect(subject).not_to be_active
          end
        end
      end
    end
  end

  describe 'to_hour' do
    subject { trigger }
    let(:trigger) { build(:trigger, attributes) }
    let(:attributes) { {to_hour: 3 } }
    context 'without #from_hour' do
      it { is_expected.not_to be_valid }
    end
  end

  describe 'from_hour' do
    subject { trigger }
    let(:trigger) { build(:trigger, attributes) }
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

  context 'without a report' do
    specify { expect(build(:trigger, report: nil)).not_to be_valid }
  end

  describe '#priority' do
    it 'defaults to :medium' do
      trigger = build(:trigger)
      expect(trigger.priority).to eq "medium"
    end

    context 'missing' do
      let(:trigger) { build(:trigger, priority: nil) }
      subject { trigger }
      it { is_expected.not_to be_valid }
    end
  end


  describe '#events' do
    subject { trigger.events }
    let(:event) { create(:event, triggers: [trigger]) }
    before { event }
    it 'condition connects a trigger and a sensor' do
      is_expected.to include(event)
    end
  end

  describe '#sensors' do
    subject { trigger.sensors }
    before { create(:condition, trigger: trigger, sensor: sensor) }
    it 'condition connects a trigger and a sensor' do
      is_expected.to include(sensor)
    end
  end

  describe '#destroy' do
    describe '#conditions' do
      let(:conditions) do
        create_list(:condition, 3, trigger: trigger)
        create(:condition)
      end
      before { conditions }

      it 'get destroyed' do
        expect{ trigger.destroy }.to change{ Condition.count }.from(4).to(1)
      end
    end
  end


  describe '#active?' do
    subject { trigger.active? }
    context 'without any conditions is considered active' do
      it { is_expected.to be_truthy }
    end

    context 'with connected sensor' do
      let(:condition) { create :condition, sensor: sensor, trigger: trigger, from: 1, to: 3 }
      before { condition }

      context 'and last calibrated value in range' do
        before { create :sensor_reading, sensor: sensor, calibrated_value: 2 }
        it { is_expected.to be_truthy }
      end

      context 'and last calibrated value outside range' do
        before { create :sensor_reading, sensor: sensor, calibrated_value: 0 }
        it { is_expected.to be_falsy }
      end

      context 'edge cases: a boundary of a condition is nil' do
        [ {from: nil, to: 23,  value_in: 21, value_out: 24},
          {from:23,   to: nil, value_in: 24, value_out: 21} ].each do |hash|
          context ":from=#{hash[:from].inspect} but :to=#{hash[:to].inspect}" do
            let(:condition) do
              create(:condition,
                     sensor: sensor,
                     trigger: trigger,
                     from: hash[:from],
                     to: hash[:to])
            end

            describe 'extends to infinity' do
              before { create :sensor_reading, sensor: sensor, calibrated_value: hash[:value_in] }
              it { is_expected.to be_truthy }
            end

            describe 'opposite boundary still required' do
              before { create :sensor_reading, sensor: sensor, calibrated_value: hash[:value_out] }
              it { is_expected.to be_falsy}
            end
          end
        end
      end



      context 'with sensor readings of different intentions' do
        before do
          create :sensor_reading, sensor: sensor, calibrated_value: 0, intention: :real
          create :sensor_reading, sensor: sensor, calibrated_value: 2, intention: :fake
        end

        describe '#active? :real' do
          subject { trigger.active? DiaryEntry.new(intention: :real) }
          it { is_expected.to be_falsy }
        end
        describe '#active? :fake' do
          subject { trigger.active? DiaryEntry.new(intention: :fake) }
          it { is_expected.to be_truthy }
        end
      end
    end
  end
end
