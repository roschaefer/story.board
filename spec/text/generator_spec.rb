require 'rails_helper'
require 'capybara/rspec'

RSpec.describe Text::Generator do
  let(:report)                { Report.current }
  let(:intention)             { :real }
  let(:generator) { described_class.new(report: report, opts: {intention: intention}) }
  subject { generator }

  describe '#html_main_part' do
    subject { generator.html_main_part }
    before do
      allow(generator).to receive(:components) { components }
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
  end


  context 'for text components with the same report and the same channel' do
    let(:text_component_params) { { report: report } }

    describe '#choose_heading' do
      subject { generator.choose_heading }
      let(:report) { create(:report) }

      context 'given several text_components' do

        context 'every text component has a trigger with a different priority' do
          let!(:text_components) do
            [
              create(:text_component, text_component_params.merge(heading: 'Text component 1', triggers: [create(:trigger, priority: :high)])),
              create(:text_component, text_component_params.merge(heading: 'Text component 2', triggers: [create(:trigger, priority: :medium)])),
              create(:text_component, text_component_params.merge(heading: 'Text component 3', triggers: [create(:trigger, priority: :low)])),
            ]
          end

          it { is_expected.to eq 'Text component 1'}
        end

        context 'every text component has a trigger with the same priority' do
          let!(:text_components) do
            [
              create(:text_component, text_component_params.merge(heading: 'Text component 1', triggers: [create(:trigger, priority: :medium)])),
              create(:text_component, text_component_params.merge(heading: 'Text component 2', triggers: [create(:trigger, priority: :medium)])),
              create(:text_component, text_component_params.merge(heading: 'Text component 3', triggers: [create(:trigger, priority: :medium)])),
            ]
          end
          it { is_expected.to match(/Text component/)} # any of those headings
        end
      end

      context 'given text_components without triggers' do
        let!(:text_components) do
          [
            create(:text_component, text_component_params.merge(heading: 'Text component 1', triggers: [create(:trigger, priority: :medium)])),
            create(:text_component, text_component_params.merge(heading: 'Text component 2', triggers: [])),
          ]
        end
        it { is_expected.to eq 'Text component 1'} # priority nil is lowest
      end

    end

    describe '#generate' do
      subject { generator.generate }

      it { is_expected.to eq({heading: '', introduction: '', main_part: '', closing: ''}) }

      context 'given one text_component' do
        let(:report)         { create(:report) }
        let!(:text_component) { create(:text_component, text_component_params.merge(main_part: main_part)) }
        let(:main_part)      { "some content" }

        it { is_expected.to have_value("<p>some content</p>\n")}

        describe 'report markup' do
          describe 'report name' do
            let(:report)    { create(:report, name: 'Foobar') }
            let(:main_part) { "Say something about { report}." }
            it { is_expected.to have_value("<p>Say something about Foobar.</p>\n")}
          end

          describe 'report variables' do
            let(:report)    { create(:report, variables: variables) }
            let(:variables) { [ create(:variable, key: 'cool_thing', value: 'sth. cool') ] }
            let(:main_part) { "Say something about { cool_thing }." }
            it { is_expected.to have_value("<p>Say something about sth. cool.</p>\n")}

            context 'many variables' do
              let(:main_part) { "Write about { v1 } and { v2 }." }
              let(:variables) { [ create(:variable, key: 'v1', value: 'this'),
                                  create(:variable, key: 'v2', value: 'that'),] }
              it { is_expected.to have_value("<p>Write about this and that.</p>\n")}
            end
          end
        end

        context 'given a trigger for the text component' do
          let(:trigger) { create(:trigger, text_components: [text_component]) }

          context 'given an event' do
            let(:event)      { create(:event, id: 42, name: "DEATH", triggers: [trigger], happened_at: nil) }
            before { event }
            it('event must happen first') { is_expected.to eq({heading: '', introduction: '', main_part: '', closing: ''}) }
            context 'has happened' do
              before { event.happened_at = DateTime.parse('2018-02-02'); event.save! }
              it { is_expected.to have_value("<p>some content</p>\n")}

              describe 'markup for the day of the event' do
                let(:main_part)      { 'Day of your death: { date(42) }' }
                it 'renders the day of the event' do
                  is_expected.to have_value("<p>Day of your death: 2.2.2018</p>\n")
                end
              end
            end
          end

          context 'given a condition' do
            let(:condition)      { create(:condition, sensor: sensor, trigger: trigger, from: 0, to: 10) }
            let(:sensor)         { create(:sensor, name: 'SensorXY', sensor_type: sensor_type) }
            let(:sensor_type)    { create(:sensor_type, property: 'Temperature', unit: '°C') }
            before { condition }
            it('condition must hold') { is_expected.to eq({heading: '', introduction: '', main_part: '', closing: ''}) }


            context 'given sensor data' do
              let(:reading)        { create(:sensor_reading, sensor: sensor, calibrated_value: 5) }
              before { report; reading }

              it { is_expected.to have_value("<p>some content</p>\n")}

              context 'with markup for sensor' do
                let(:sensor)         { create(:sensor, id: 42, name: 'SensorXY', sensor_type: sensor_type) }
                let(:main_part)      { 'Sensor value: { value(42) }' }
                it('renders sensor value') { is_expected.to have_value("<p>Sensor value: 5.0°C</p>\n")}
                context 'but with sensor data of different intention' do
                  before { reading; create(:sensor_reading, sensor: sensor, intention: :fake, calibrated_value: 0) }

                  context 'render :fake report' do
                    let(:intention) { :fake }
                    it { is_expected.to have_value("<p>Sensor value: 0.0°C</p>\n")}
                  end

                  context 'render :real report' do
                    let(:intention) { :real }
                    it { is_expected.to have_value("<p>Sensor value: 5.0°C</p>\n")}
                  end
                end
              end

              context 'markup references an unknown sensor' do
                let!(:text_component)  { create(:text_component, :active, text_component_params.merge(main_part: main_part)) }
                let(:main_part)       { "Sensor value: { valueOf(4711) }" }
                it { expect(text_component.sensors.pluck(:id)).not_to include(4711)}
                it { expect(text_component).to be_active }
                describe 'markup' do
                  it('will be ignored') { is_expected.to have_value("<p>Sensor value: { valueOf(4711) }</p>\n")}
                end
              end
            end
          end
        end
      end
    end
  end
end
