require 'rails_helper'

RSpec.describe DiaryEntry, type: :model do
  describe 'HTML output' do
    let(:report) { Report.current }
    let(:diary_entry) { DiaryEntry.new(report: report, release: release) }
    let(:release)     { :final }

    describe '#heading' do
      subject { diary_entry.heading }
      context 'with a text component' do
        before { report.text_components << create(:text_component, heading: 'Assigned heading') }
        it { is_expected.to eq('Assigned heading') }
      end

      describe 'markup in heading' do
        before do
          report.text_components << create(:text_component, report: report, heading: "What's up { name }?")
          create(:variable, report: report, key: 'name', value: 'Bertha')
        end
        it { is_expected.to eq "What's up Bertha?" }
      end

      context 'given several text_components' do
        context 'every text component has a trigger with a different priority' do
          let!(:text_components) do
            [
              create(:text_component, report: report, heading: 'Text component 1', triggers: [create(:trigger, priority: :high)]),
              create(:text_component, report: report, heading: 'Text component 2', triggers: [create(:trigger, priority: :medium)]),
              create(:text_component, report: report, heading: 'Text component 3', triggers: [create(:trigger, priority: :low)]),
            ]
          end
          it { is_expected.to eq 'Text component 1'}
        end

        context 'every text component has a trigger with the same priority' do
          let!(:text_components) do
            [
              create(:text_component, report: report, heading: 'Text component 1', triggers: [create(:trigger, priority: :medium)]),
              create(:text_component, report: report, heading: 'Text component 2', triggers: [create(:trigger, priority: :medium)]),
              create(:text_component, report: report, heading: 'Text component 3', triggers: [create(:trigger, priority: :medium)]),
            ]
          end
          it { is_expected.to match(/Text component/)} # any of those headings
        end
      end

      context 'given text_components without triggers' do
        let!(:text_components) do
          [
            create(:text_component, report: report, heading: 'Text component 1', triggers: [create(:trigger, priority: :medium)]),
            create(:text_component, report: report, heading: 'Text component 2', triggers: []),
          ]
        end
        it { is_expected.to eq 'Text component 1'} # priority nil is lowest
      end
    end

    describe '#introduction' do
      subject { diary_entry.introduction }
      context 'more than 3 text components' do
        before { report.text_components << create_list(:text_component, 5, report: report, introduction: 'Crazy introduction') }

        it 'contains no more than 3 introductions' do
          expect(subject.scan(/Crazy/).count).to eq 3
        end
      end
    end

    describe '#main_part' do
      subject { diary_entry.main_part }
      let(:components) { [] }
      before { report.text_components << components }

      context 'with a text component' do
        let(:components) { create_list(:text_component, 1, main_part: 'Main part') }
        it { is_expected.to eq("<p>Main part<span class='resi-thread'>\n</span>\n</p>\n") }
      end

      context 'without components' do
        let(:components) { [] }
        it { is_expected.to be_empty }
      end

      context 'only one component' do
        let(:components) { build_list(:text_component, 1, heading: 'subheading', main_part: main_part) }
        let(:main_part) { 'main_part' }

        it { is_expected.not_to include('subheading') }
        it { is_expected.to include('main_part') }

        context 'and a loooooong text' do
          let(:main_part) { 'a' * 50000 }
          it 'contains all the text' do
            parsed = Capybara.string(subject)
            expect(parsed.text.strip.length).to eq 50000
          end
        end
      end

      describe 'overfull text' do
        describe 'text breaks' do
          let(:components) { build_list(:text_component, 10, heading: 'subheading', main_part: ('blah' * 500)) }

          it 'with headings as subheadings' do
            parsed = Capybara.string(subject)
            expect(parsed.text.split('subheading').count).to eq 10
          end
        end

        describe 'subheadings' do
          let(:text) { Capybara.string(subject).text }
          let(:components) { [
            build(:text_component, heading: '1st heading', main_part: ('long first part ' * 50)),
            build(:text_component, heading: '2nd heading will be used as break', main_part: ('short second part ')),
            build(:text_component, heading: '3rd heading', main_part: ('long third part ' * 50))
          ] }
          before { allow(diary_entry).to receive(:sorted_components) {components} } # enforce this order


          it 'heading of next component becomes subheading' do
            expect(text.split('heading').count).to eq 2
            expect(text).to include('2nd heading')
          end

          it 'any heading that is not used as subheading will be dropped' do
            expect(text).not_to include('1st heading')
            expect(text).not_to include('3rd heading')
          end
        end
      end

      describe 'question/answers' do
        subject { Capybara.string(diary_entry.main_part) }

        describe 'markup' do
          let(:components) { build_list(:text_component, 1, report: Report.current, question_answers: question_answers) }
          let(:variables) { create_list(:variable, 1, key: 'name', value: 'Bertha') }
          before { Report.current.variables << variables }
          context 'in question' do
            let(:question_answers) { build_list(:question_answer, 1, question: 'Do you know { name }?') }
            it 'gets rendered' do
              is_expected.to have_text 'Do you know Bertha?'
            end
          end

          context 'in answer' do
            let(:question_answers) { build_list(:question_answer, 1, answer: 'May I introduce - { name }.') }
            it 'gets rendered' do
              is_expected.to have_text 'May I introduce - Bertha.'
            end
          end
        end

        context 'one component with many question/answers' do
          let(:question_answers) { build_list(:question_answer, 3) }
          let(:components) { build_list(:text_component, 1, question_answers: question_answers) }

          describe 'thread' do
            it { is_expected.to have_css('.resi-thread', count: 1) }
            it { is_expected.to have_css('.resi-thread .resi-question', count: 3) }
            it { is_expected.to have_css('.resi-thread .resi-answer', count: 3) }
          end
        end

        context 'many text components' do
          let(:components) { build_list(:text_component, 3) }
          describe 'threads' do
            it { is_expected.to have_css('.resi-thread', count: 3) }
          end
        end
      end

      it { is_expected.to eq '' }

      context 'given one text_component' do
        let(:report)          { create(:report) }
        let(:components)  { create_list(:text_component, 1, report: report, main_part: main_part) }
        let(:main_part)       { "some content" }

        it { is_expected.to include('some content') }

        describe 'report markup' do
          describe 'report name' do
            let(:report)    { create(:report, name: 'Foobar') }
            let(:main_part) { "Say something about { report}." }
            it { is_expected.to include('Say something about Foobar.') }
          end

          describe 'report variables' do
            let(:report)    { create(:report, variables: variables) }
            let(:variables) { [ create(:variable, key: 'cool_thing', value: 'sth. cool') ] }
            let(:main_part) { "Say something about { cool_thing }." }
            it { is_expected.to include('Say something about sth. cool.') }

            context 'many variables' do
              let(:main_part) { "Write about { v1 } and { v2 }." }
              let(:variables) { [ create(:variable, key: 'v1', value: 'this'),
                                  create(:variable, key: 'v2', value: 'that'),] }
              it { is_expected.to include('Write about this and that.') }
            end
          end
        end

        context 'given a trigger for the text component' do
          let(:text_component) { components.first }
          let(:trigger) { create(:trigger, text_components: [text_component]) }

          context 'given an event' do
            let(:event)      { create(:event, id: 42, name: "DEATH", triggers: [trigger]) }
            before { event }
            it('event must happen first') { is_expected.to eq('') }
            context 'is happening now' do
              before { event.start(Time.zone.parse('2017-02-02')) }
              it { is_expected.to include('some content') }

              describe 'markup for the day of the event' do
                let(:main_part)      { 'Day of your death: { date(42) }' }
                it('renders the day of the event') { is_expected.to include('Day of your death: 2.2.2017') }
              end
            end
          end

          context 'given a condition' do
            let(:condition)      { create(:condition, sensor: sensor, trigger: trigger, from: 0, to: 10) }
            let(:sensor)         { create(:sensor, name: 'SensorXY', sensor_type: sensor_type) }
            let(:sensor_type)    { create(:sensor_type, property: 'Temperature', unit: '°C') }
            before { condition }
            it('condition must hold') { is_expected.to eq ('') }


            context 'given sensor data' do
              let(:reading)        { create(:sensor_reading, sensor: sensor, calibrated_value: 5) }
              before { reading }

              it { is_expected.to include('some content') }

              context 'with markup for sensor' do
                let(:sensor)         { create(:sensor, id: 42, name: 'SensorXY', sensor_type: sensor_type) }
                let(:main_part)      { 'Sensor value: { value(42) }' }
                it { is_expected.to include('Sensor value: 5.0 °C') }
                context 'but with sensor data of different release' do
                  before { reading; create(:sensor_reading, sensor: sensor, release: :debug, calibrated_value: 0) }

                  context 'render :debug report' do
                    let(:release) { :debug }
                    it { is_expected.to include('Sensor value: 0.0 °C') }
                  end

                  context 'render :final report' do
                    let(:release) { :final }
                    it { is_expected.to include('Sensor value: 5.0 °C') }
                  end
                end
              end

              context 'markup references an unknown sensor' do
                let(:components)  { create_list(:text_component, 1, :active, report: report, main_part: main_part) }
                let(:main_part)   { "Sensor value: { valueOf(4711) }" }
                describe 'markup' do

                  it('will be ignored') do
                    text_component = components.first
                    expect(text_component.sensors.pluck(:id)).not_to include(4711)
                    expect(text_component.active?(diary_entry)).to be_truthy
                    expect(subject).to include('Sensor value: { valueOf(4711) }')
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
