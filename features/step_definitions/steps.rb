# frozen_string_literal: true

def number_or_nil(number_string)
  Integer(number_string)
rescue StandardError
  nil
end

def within_text_component_section(header)
  within('.form__section', text: header) do
    find('a', text: 'Edit').click if page.has_css?('a', text: 'Edit')
    yield
  end
end

When(/^I visit the landing page$/) do
  visit root_path
end

When(/^I reload the page$/) do
  visit current_path
end

Then(/^I should see:$/) do |string|
  expect(page).to have_text string
end

Given(/^I have a sensor called "([^"]*)"$/) do |name|
  @sensor = create(:sensor, name: name)
end

Given(/^I have a sensor for the current report called "([^"]*)"$/) do |name|
  @sensor = create(:sensor, name: name, report: Report.current)
end

Given(/^I have a sensor with id (\d+)$/) do |id|
  @sensor = create :sensor, id: id
end

Then(/^a new sensor reading was created$/) do
  expect(Sensor::Reading.count).to eq 1
end

Given(/^I have no sensor in my database$/) do
  expect(Sensor.count).to eq 0
end

Then(/^no sensor reading was created$/) do
  expect(Sensor::Reading.count).to eq 0
end

Given(/^all "([^"]*)" sensors measure in "([^"]*)"$/) do |property, unit|
  create(:sensor_type, property: property, unit: unit)
end

When(/^I want to create a new sensor/) do
  visit new_report_sensor_path(Report.current)
  fill_in :sensor_name, with: 'SensorXYZ'
end

When(/^I select the sensor type "([^"]*)"$/) do |type|
  select type, from: 'sensor_sensor_type_id'
end

When(/^I confirm the dialog$/) do
  find('input[type="submit"]').click
end

Then(/^I have a new sensor in my database$/) do
  expect(Sensor.count).to eq 1
end

Given(/^I have a ([^"]*) sensor called "([^"]*)"$/) do |property, name|
  temperature_type = create(:sensor_type, property: property.capitalize)
  create(:sensor, name: name, sensor_type: temperature_type, report: Report.current)
end

Given(/^I have a trigger with the name "([^"]*)"$/) do |name|
  @trigger = create(:trigger, name: name, report: Report.current)
end

When(/^I visit the edit page of this trigger$/) do
  visit edit_report_trigger_path(Report.current, @trigger)
end

When(/^I add a condition$/) do
  find('button', text: /Add sensor/).click
  expect(page).to have_css('button[type="button"].btn-danger', text: '×') # wait until it's there
end

When(/^(?:when )?I choose the sensor "([^"]*)" to trigger this trigger$/) do |sensor|
  find('.choose_sensor').select sensor
end

When(/^I define a range from "([^"]*)" to "([^"]*)" to cover the relevant values$/) do |arg1, arg2|
  execute_script("$('.range').data('range').value('#{arg1},#{arg2}')")
end

When(/^I click on update$/) do
  click_on 'Update'
  expect(page).to have_text('Edit') # wait until saved
end

Then(/^the trigger is connected to the ([^"]*) sensor$/) do |property|
  @trigger.reload
  expect(@trigger.sensors).not_to be_empty
  expect(@trigger.sensors.first.sensor_type.property).to eq property.capitalize
end

Then(/^the condition has relevant values from "([^"]*)" to "([^"]*)"$/) do |arg1, arg2|
  @trigger.reload
  expect(@trigger.conditions.first.from).to eq arg1.to_f
  expect(@trigger.conditions.first.to).to   eq arg2.to_f
end

Given(/^this sensor just measured a .* of (\d+)°C$/) do |value|
  create(:sensor_reading, sensor: @sensor, calibrated_value: value)
end

Given(/^I prepared a text component with this introduction:$/) do |introduction|
  @text_component = create(:text_component, report: Report.current, introduction: introduction)
end

Given(/^this trigger should trigger for a value between (\d+)°C and (\d+)°C$/) do |from, to|
  expect(@trigger.conditions.length).to eq 1 # sanity check - just in case
  condition = @trigger.conditions.first
  condition.from = from
  condition.to = to
  condition.save!
end

Given(/^for my current report I have these triggers prepared:$/) do |table|
  table.hashes.each do |row|
    trigger = create(:trigger,
                     report: Report.current,
                     name: row['Trigger'])
    sensor = Sensor.find_by(name: row['Sensor']) || create(:sensor, name: row['Sensor'], report: Report.current)
    create(:condition, sensor: sensor, trigger: trigger, from: row['From'], to: row['To'])
  end
end

Given(/^for my sensors I have these triggers prepared:$/) do |table|
  table.hashes.each do |row|
    trigger = create(:trigger, report: Report.current, name: row['Trigger'], validity_period: row['Validity'])
    sensor = Sensor.find_by name: row['Sensor']
    create(:condition, sensor: sensor, trigger: trigger, from: row['From'], to: row['To'])
  end
end

Given(/^the latest sensor data looks like this:$/) do |table|
  table.hashes.each do |row|
    sensor = Sensor.find_by(name: row['Sensor'])
    reading_attr = { sensor: sensor, calibrated_value: row['Calibrated Value'].to_i }
    reading = create(:sensor_reading, reading_attr)
    created_at_code = row['Created at']
    if created_at_code
      reading.created_at = eval(created_at_code.downcase.tr(' ', '.'))
      reading.save!
    end
  end
end

Then(/^I should NOT see:$/) do |string|
  string.split('[or]').each do |part|
    expect(page).not_to have_content(part.strip)
  end
end

Given(/^I am (?:a|the) (?:journalist|service team member)/) do
  @user ||= create(:user)
  log_in @user
end

Given(/^there is a sensor live report/) do
  expect(Report.current).to be_present
  expect(Channel.sensorstory).to be_present
end

When(/^(?:when )?I choose "([^"]*)" to be the start date for the experiment$/) do |start_date|
  @date = Date.parse(start_date)

  day, month, year = start_date.split
  select year, from: 'report_start_date_1i'
  select month, from: 'report_start_date_2i'
  select day, from: 'report_start_date_3i'
end

Then(/^the live report about "([^"]*)" will start on that date$/) do |name|
  expect(Report.find_by(name: name).start_date).to eq @date
end

Given(/^my current live report is called "([^"]*)"$/) do |name|
  report = Report.current
  report.name = name
  report.save
end

When(/^I click on "([^"]*)"/) do |thing|
  click_on thing
end

When(/^I click on the dropdown menu with my user account on the top right$/) do
  find('#user-menu').click
end

When(/^I type in a name$/) do
  fill_in 'Name', with: 'Blablablabla'
end

Then(/^I have a new trigger for my live report in the database$/) do
  current_report = Report.current
  expect(current_report.triggers).not_to be_empty
end

When(/^I choose (\d+) random sensor readings with a value from (\d+)°C to (\d+)°C$/) do |quantity, from, to|
  fill_in 'Quantity', with: quantity
  fill_in 'From', with: from
  fill_in 'To', with: to
end

Then(/^this sensor should have (\d+) new sensor readings as debug data$/) do |quantity|
  expect(@sensor.sensor_readings.debug.count).to eq quantity.to_i
end

Then(/^I should see some generated entries in the sensor readings (debug|final) table$/) do |version|
  within "#sensor-readings-table-#{version}" do
    expect(page).to have_css('.sensor-reading-row')
  end
end

Given(/^I have debug and final sensor readings for sensor "([^"]*)"$/) do |name|
  @sensor = Sensor.find_by(name: name)
  Sensor::Reading.transaction do
    7.times { create(:sensor_reading, sensor: @sensor, release: :debug) }
    5.times { create(:sensor_reading, sensor: @sensor, release: :final) }
  end
end

When(/^I (?:see|visit) the page of (?:this|that) sensor$/) do
  visit report_sensor_path(Report.current, @sensor)
end

Then(/^debug and final data are distinguishable$/) do
  within '#sensor-readings-table-debug' do
    expect(page).to have_css('.sensor-reading-row', count: 7)
  end
  within '#sensor-readings-table-final' do
    expect(page).to have_css('.sensor-reading-row', count: 5)
  end
end

Given(/^there is some generated test data:$/) do |table|
  ActiveRecord::Base.transaction do
    table.hashes.each do |row|
      sensor = Sensor.find_by(name: row['Sensor'])
      create(:sensor_reading, sensor: sensor, calibrated_value: row['Calibrated Value'].to_i, release: :debug)
    end
  end
end

Then(/^I can read this text:$/) do |string|
  string.split('[...]').each do |part|
    expect(page).to have_text(part.strip)
  end
end

Given(/^I have a sensor with a I2C address "([^"]*)"$/) do |address|
  @sensor = create(:sensor, address: address)
end

Then('now the sensor has the following readings in the database:') do |table|
  table.hashes.each do |row|
    r = Sensor::Reading.find_by(sensor_id: @sensor.id, calibrated_value: row['Calibrated value'], uncalibrated_value: row['Uncalibrated value'])
    expect(r).to be_a(Sensor::Reading)
  end
  expect(@sensor.sensor_readings.count).to eq(table.hashes.count)
end

When(/^I choose an address "([^"]*)"$/) do |address|
  fill_in 'Address', with: address
end

When(/^by the way, the "([^"]*)" attribute above is a string$/) do |arg1|
  # only documentation
end

When(/^I select "([^"]*)" from the priorities$/) do |selection|
  select selection, from: 'trigger_priority'
end

Then(/^my heading has become very important$/) do
  expect(page).to have_text('Priority: high')
  @trigger.reload
  expect(@trigger.priority).to eq 'high'
end

Given(/^I have (\d+) entries for a sensor in my database$/) do |quantity|
  Sensor.transaction do
    @sensor = create(:sensor)
    Sensor::Reading.transaction do
      quantity.to_i.times do
        create(:sensor_reading, sensor: @sensor)
      end
    end
  end
end

Then(/^I see only (\d+) sensor readings$/) do |times|
  expect(page).to have_css('.sensor-reading-row', count: times)
end

Then(/^the first row is the most recent sensor reading$/) do
  id = page.first('.sensor-reading-row')[:id]
  id = id.sub('sensor-reading-', '')
  first_row = Sensor::Reading.find(id)
  most_recent = Sensor::Reading.order(:created_at).last
  expect(first_row.id).to eq most_recent.id
end

Given(/^I have these sensors and sensor types in my database$/) do |table|
  table.hashes.each do |row|
    sensor_type = create(:sensor_type, property: row['Property'], unit: row['Unit'], min: row['Min'], max: row['Max'], fractionDigits: (row['FractionDigits'] || 1))
    create(:sensor,
           id: row['SensorID'].to_i,
           name: row['Sensor'],
           sensor_type: sensor_type,
           report: Report.current)
  end
end

When(/^I add a video URL to the report$/) do
  click_on 'Edit'
  @url = '//example.com/embedded/live/example?autoplay=1'
  fill_in 'Video URL', with: @url
  click_on 'Update Report'
end

Then(/^I can watch a video stream that points to this url$/) do
  expect(page).to have_css('iframe')
  expect(find('iframe')['src']).to eq @url
end

When(/^I set the component to trigger only for recent data within the last "([^"]*)" hours$/) do |hours|
  fill_in 'Validity period', with: hours
end

Then(/^this trigger has a validity period of "([^"]*)" hours$/) do |hours|
  @trigger.reload
  expect(@trigger.validity_period).to eq hours.to_f
end

Given(/^I see the (?:current|new)? live report/) do |string|
  expect(page).to have_css('.live-report')
  string.split('[...]').each do |part|
    expect(find('.live-report')).to have_text part
  end
end

Then(/^I can see these pieces of text in the report:$/) do |table|
  expect(page).to have_css('.live-report')
  table.hashes.each do |row|
    expect(find('.live-report')).to have_text row['Part']
  end
end

Then(/^I can see the archived report:$/) do |string|
  expect(page).to have_css('.archived-report')
  expect(find('.archived-report')).to have_text string
end

When(/^the application archives the current report$/) do
  load 'Rakefile'
  task = 'archive'
  Rake::Task[task].invoke
end

When(/^I change the name of the report to "([^"]*)"$/) do |name|
  @report_name = name
  fill_in 'Name', with: @report_name
end

Then(/^I see the new name in the settings menu above$/) do
  expect find('.subnav__breadcrumb option[selected]', text: @report_name, count: 1)
end

Given(/^there is a triggered text component with the following main part:$/) do |main_part|
  create(:text_component, main_part: main_part, report: Report.current)
end

Given(/^there is an unpublished text component with the following main part:$/) do |main_part|
  @text_component = create(:text_component, main_part: main_part, report: Report.current, publication_status: :draft)
end

Given(/I change the text component's publication status to "([^"]*)"$/) do |status|
  @text_component.update! publication_status: status
end

Given(/^I have these active triggers:$/) do |table|
  table.hashes.each do |row|
    create(:trigger, :active,
           name: row['Trigger'],
           report: Report.current)
  end
end

Then(/^I should see only one of the following:$/) do |string|
  parts = string.split('[OR]').collect(&:strip)
  seen_parts = parts.select { |p| page.text.include?(p) }
  expect(seen_parts.length).to eq 1
end

Given(/^I have these custom variables for my report:$/) do |table|
  table.hashes.each do |row|
    key = row['Key']
    value = row['Value']
    create(:variable, report: Report.current, key: key, value: value)
  end
end

When(/^I edit the settings of my current live report$/) do
  visit edit_report_path(Report.current)
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |label, value|
  fill_in label, with: value
end

Then(/^I see that my custom variable "([^"]*)" has a value "([^"]*)"$/) do |key, value|
  expect(page).to have_css('.variables-table')
  row = find('tr', text: /#{key}/)
  expect(row).to have_text(value)
end

Given(/^(?:we|I) have these events in (?:my|our) database:$/) do |table|
  table.hashes.each do |row|
    create(:event, id: row['EventID'], name: row['Event'])
  end
end

Given(/^have some triggers prepared that will trigger on a particular event$/) do |table|
  table.hashes.each do |row|
    event = Event.find_by(name: row['Event'])
    create(:trigger, report: Report.current, name: row['Name'], events: [event])
  end
end

Given(/^the event "([^"]*)" has happened on "([^"]*)"$/) do |name, date|
  event = Event.find_by(name: name)
  event.start(Time.zone.parse(date))
end

Given(/^we have this sensor data in our database:$/) do |table|
  table.hashes.each do |row|
    sensor = Sensor.find_by(name: row['Sensor'])
    create(:sensor_reading,
           sensor: sensor,
           calibrated_value: row['Calibrated value'],
           created_at: row['Created at'])
  end
end

When(/^I append the following parameter to the url:$/) do |string|
  path = current_path + string
  visit path
end

Then(/^according to the live report it is summer again!$/) do |string|
  expect(page).to have_text(string)
end

Given(/^there is also a medium prioritized, active component with a really long text$/) do
  main_part = 'Blaaa' + 500.times.collect { 'a' }.join + 'aaahhhh!'
  trigger = create(:trigger, :active, priority: :medium)
  create(:text_component, :active,
         report: Report.current,
         main_part: main_part,
         triggers: [trigger])
end

Then(/^I can see the main heading:$/) do |string|
  expect(page).to have_css('.main-heading', text: string)
end

Then(/^I can see a subheading:$/) do |string|
  expect(page).to have_css('.sub-heading', text: string)
end

Given(/^my reporter box has the id "([^"]*)"$/) do |id|
  # as long as we don't have the box, fake it
  Command::DEVICE_ID = id
end

Given(/^there is an actuator connected at port "([^"]*)"/) do |port|
  @actuator = create(:actuator, port: port)
end

When(/^I visit the page of this actuator$/) do
  visit actuator_path(@actuator)
end

Then(/^a request will be sent to this url:$/) do |url|
  expect(@command.url).to eq url
end

Then(/^the request payload contains this data:$/) do |string|
  payload = 'args=' + @command.argument
  expect(payload).to eq string
end

When(/^I click the 'Activate' button to trigger the actuator$/) do
  VCR.use_cassette('actuators/activate') do
    click_on 'Activate'
  end
  @command = Command.last
end

Then(/^the command was successfully executed$/) do
  expect(@command).to be_executed
end

When(/^I click the 'Deactivate' button$/) do
  VCR.use_cassette('actuators/deactivate') do
    click_on 'Deactivate'
  end
  @command = Command.last
end

Given(/^there is an actuator called "([^"]*)" connected at port "([^"]*)"$/) do |name, port|
  create(:actuator, name: name, port: port)
end

Given(/^I have configured this chain:$/) do |table|
  table.hashes.each do |row|
    actuator = Actuator.find_by(name: row['Actuator'])
    create(:chain,
           actuator: actuator,
           hashtag: row['Hashtag'],
           function: row['Function'])
  end
end

When(/^we receive this tweet from user @vicari for hashtag "([^"]*)":$/) do |hashtag, string|
  create(:tweet, user: '@vicari', main_hashtag: hashtag, message: string)
end

Then(/^the following command is appended:$/) do |table|
  row = table.hashes.first
  command = Command.last
  expect(command.function).to eq row['Function']
  expect(command.status).to eq row['Status']
  expect(command.actuator.name).to eq row['Actuator']
end

When(/^enter "([^"]*)" as duration for my experiment$/) do |duration|
  fill_in 'Duration', with: duration.to_i
end

Then(/^I can see that my experiment will end on "([^"]*)"$/) do |date|
  expect(page).to have_text(date)
end

When(/^I visit the sensors page$/) do
  visit report_sensors_path(Report.current)
end

Given(/^these are the connections between text components and triggers:$/) do |table|
  table.hashes.each do |row|
    trigger = Trigger.find_by(name: row['Trigger'])
    create(:text_component,
           main_part: row['Text component'],
           triggers: [trigger],
           report: Report.current)
  end
end

Given(/^I have these text components with their highest priority:$/) do |table|
  table.hashes.each do |row|
    trigger = create(:trigger, :active, priority: row['Highest priority'])
    create(:text_component, triggers: [trigger], heading: row['Heading'], report: Report.current)
  end
end

Given(/^and this component should trigger for a value between (\d+)°C and (\d+)°C$/) do |from, to|
  condition = create(:condition, sensor: @sensor, from: from, to: to)
  @text_component.triggers = [condition.trigger]
  @text_component.save!
end

Given(/^I have two short text commponents, that are active right now:$/) do |table|
  table.hashes.each do |row|
    trigger = create(:trigger, :active, priority: row['Highest priority'])
    create(:text_component,
           heading: row['Heading'],
           triggers: [trigger],
           report: Report.current)
  end
end

Given(/^I have a text component with a heading "([^"]*)"$/) do |heading|
  @text_component = create(:text_component, heading: heading, report: Report.current)
end

Given(/^we have a text component called "([^"]*)":$/) do |heading, text|
  @text_component = create(:text_component, heading: heading, main_part: text, report: Report.current)
end

When(/^I add a trigger and choose "([^"]*)"$/) do |trigger|
  within_text_component_section('Trigger') do
    find('.choices', wait: 10).click
    find('.choices__item', text: trigger).click
  end
end

When(/^I add another trigger and choose "([^"]*)"$/) do |trigger|
  find('.choices').click
  find('.choices__item', text: trigger).click
end

Then(/^the text component is connected to both triggers$/) do
  expect(@text_component.triggers.count).to eq 2
end

Given(/^I have these text components with the corresponding schedule in my database:$/) do |table|
  table.hashes.each do |row|
    create(:text_component,
           main_part: row['Text component'],
           report: Report.current,
           from_day: number_or_nil(row['From day']),
           to_day: number_or_nil(row['To day']))
  end
end

Given(/^it's the 2nd day of the experiment$/) do
  report = Report.current
  report.start_date = 2.days.ago
  report.save
end

When(/^I wait for (\d+) days$/) do |number|
  Timecop.travel(Time.now + number.to_i.days)
end

Given(/^I have a sensor for "([^"]*)"$/) do |property|
  @sensor = create(:sensor,
                   report: Report.current,
                   sensor_type: create(:sensor_type, property: property))
end

When(/^I visit its sensor page$/) do
  visit report_sensor_path(Report.current, @sensor)
end

When(/^all subsequent sensor readings will be intercepted for a while$/) do
  # send and accept JSON
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  expect(@sensor.sensor_readings).to be_empty
  @values = [3, 5, 7, 11, 13, 17].shuffle
  @values.each do |value|
    input = {
      "sensor_id": @sensor.id,
      "calibrated_value": value,
      "uncalibrated_value": value
    }.to_json
    request report_sensor_readings_path(Report.current, @sensor), method: :post, input: input
  end
  expect(@sensor.sensor_readings).to be_empty
end

When(/^I visit the sensor page again$/) do
  visit report_sensor_path(Report.current, @sensor)
end

Then(/^the highest and lowest values will be stored as extreme values for the sensor$/) do
  @sensor.reload
  expect(@sensor.max_value).to eq 17
  expect(@sensor.min_value).to eq 3
  expect(@sensor.calibrated_at).not_to be_nil
end

Then(/^I can see the calibration values on the sensor page$/) do
  visit report_sensor_path(Report.current, @sensor)
  expect(page).to have_text('17')
  expect(page).to have_text('3')
end

Given(/^this sensor was calibrated already$/) do
  @sensor.max_value = 42
  @sensor.min_value = -11
  @sensor.calibrated_at = 1.day.ago
  @sensor.save!
end

Then(/^the calibration values of this sensor will be cleared$/) do
  @sensor.reload
  expect(@sensor.max_value).to be_nil
  expect(@sensor.min_value).to be_nil
  expect(@sensor.calibrated_at).not_to be_nil
end

Given(/^some text components are active at certain hours:$/) do |table|
  table.hashes.each do |row|
    create(:text_component,
           report: Report.current,
           heading: row['Heading'],
           main_part: row['Main part'],
           from_hour: Time.parse(row['From']).hour,
           to_hour: Time.parse(row['To']).hour)
  end
end

def edit_existing_text_component(text_component = nil)
  @text_component ||= text_component
  visit edit_report_text_component_path(@text_component.report, @text_component)
end

When(/^I edit this text component$/) do
  edit_existing_text_component
end

When(/^I update the text component$/) do
  click_on 'Update Text component'
  expect(page).to have_text('Text component was successfully updated.')
end

Given(/^our sensor live report has a channel "([^"]*)"$/) do |name|
  @channel = Channel.find_by(name: name)
  @channel ||= create(:channel, name: name, report: Report.current)
end

Given(/^a topic "([^"]*)"$/) do |name|
  @topic = create(:topic, name: name)
end

Given(/^we created a text component for it that is active right now$/) do
  create(
    :text_component,
    :active,
    report: Report.current,
    main_part: 'Got milk?',
    channels: [@channel],
    topic: @topic
  )
end

Given(/^there is a channel called "([^"]*)"$/) do |name|
  create(:channel, name: name)
end

Given(/is too difficult for everybody to understand$/) do
  # documentation
end

Given(/^I created several text components already, explaining the topic on different levels$/) do
  # documentation
end

Given(/^this is for the eggheads out there:$/) do |string|
  @difficult_text = string
  create(:text_component, main_part: @difficult_text, report: Report.current)
end

Given(/^that is more easy to savvy:$/) do |string|
  @easy = string
  @text_component = create(:text_component, heading: 'easy one', main_part: @easy, report: Report.current)
end

When(/^I edit the easier text component$/) do
  edit_existing_text_component
end

When(/^choose "([^"]*)" as a channel$/) do |channel|
  within_text_component_section('Output') do
    find('.choices').click
    find('.choices__item', text: channel).click
    find('.form__section__header').click # unfocus
  end
end

When(/^unselect "([^"]*)" as a channel$/) do |channel|
  within_text_component_section('Output') do
    find('.choices__item', text: channel).click
    find('.choices__input').send_keys(:backspace)
  end
end

Then(/^the easier text will go into the channel "([^"]*)"$/) do |channel_name|
  channel = Channel.find_by(name: channel_name)
  visit edit_channel_path(channel)
  expect(@easy).not_to be_empty
  expect(page).to have_text(@easy)
end

Then(/^the easier text will not appear in main story$/) do
  visit '/reports/current'
  expect(page).not_to have_text(@easy)
end

Given(/^this text component has these questions and answers(?: already)?:$/) do |table|
  @question_answers = []
  table.hashes.each do |row|
    question_answer = create(:question_answer, text_component: @text_component, question: row['Question'], answer: row['Answer'])
    @question_answers << question_answer
  end
end

When(/^I fill the empty question with:$/) do |string|
  @question_text = string
  find('.text_component_question_answers_question .question-input', text: /^$/).set(@question_text)
end

When(/^I enter the missing answer:$/) do |string|
  @answer_text = string.tr("\n", ' ')
  find('.text_component_question_answers_answer .answer-input', text: /^$/).set(@answer_text)
end

Then(%r{^a new question/answer was added to the database$}) do
  expect(page).to have_text('Text component was successfully updated.')
  @text_component.reload
  qa = @text_component.question_answers.last
  expect(@question_answers).not_to include(qa)
  expect(qa.question).to be_present
  expect(qa.answer).to be_present
end

Then(/^I can see the new question and the answer on the page$/) do
  expect(page).to have_text(@question_text)
  expect(page).to have_text(@answer_text)
end

When(/^I click the "([^"]*)" button$/) do |label|
  within_text_component_section('Chatbot Q/A') do
    click_button(label)
  end
end

When(/^two more input fields pop up, one for the new question and one for the new answer$/) do
  expect(page).to have_css('.text_component_question_answers_question .question-input', text: /^$/, count: 1)
  expect(page).to have_css('.text_component_question_answers_answer .answer-input', text: /^$/, count: 1)
end

Given(%r{^we have an active text component with these question/answers:$}) do |table|
  text_component = create(:text_component, report: Report.current)
  table.hashes.each do |row|
    @question = row['Question']
    @answer   = row['Answer']
    create(:question_answer, text_component: text_component, question: @question, answer: @answer)
  end
end

When(/^I read the report$/) do
  visit root_path
end

When(/^I click the button labeled with the question$/) do
  expect(page).to have_text(@question)
  expect(page).not_to have_text(@answer)
  click_button @question
end

Then(/^the button disappears and the answer shows up$/) do
  expect(page).to have_text(@anwer)
  expect(page).not_to have_text(@question)
end

Given(%r{^we have different text components, each having question/answers$}) do
  # sophisticated test set up
  create(:important_text_component,
         report: Report.current,
         heading: 'News from Bertha the cow',
         introduction: '',
         main_part: 'I gave eleven liters of milk today.',
         closing: '',
         question_answers: [
           build(:question_answer, question: 'Is this a lot?', answer: 'I would say, that\'s quite a lot.'),
           build(:question_answer, question: 'Want more?', answer: 'I hope for it.')
         ])
  create(:text_component,
         report: Report.current,
         heading: 'This heading will not be visible',
         introduction: '',
         main_part: 'It was hot and stuffy in the stable.',
         closing: 'I hope it gets colder tomorrow.',
         question_answers: [build(:question_answer, question: 'How hot was it?', answer: 'Unbearable.')])
end

def check_expanding_report(string)
  parts = string.split("\n")
  parts.each do |part|
    expect(page).to have_text(part.delete("\n"))
  end
end

Given(/^based on the input data, the current report might look like this:$/) do |string|
  visit root_path
  check_expanding_report(string)
end

When(/^I click on the question "([^"]*)"$/) do |question|
  find('.resi-question', text: question).click
end

Then(/^the text expands like this:$/) do |string|
  check_expanding_report(string)
end

Given(%r{^we have an active text component for that topic with these question/answers:$}) do |table|
  @text_component = create(:text_component,
                           channels: [Channel.chatbot],
                           topic: @topic,
                           main_part: 'The main part of the text component will be displayed here.')
  table.hashes.each do |row|
    create(:question_answer,
           text_component: @text_component,
           question: row['Question'],
           answer: row['Answer'])
  end
end

Given(%r{^we have an active text component with the id (\d+) for that topic with these question/answers:$}) do |id, table|
  @text_component = create(:text_component,
                           report: Report.current,
                           channels: [Channel.chatbot],
                           topic: @topic,
                           main_part: 'The main part of the text component will be displayed here.',
                           id: id)
  table.hashes.each do |row|
    create(:question_answer,
           text_component: @text_component,
           question: row['Question'],
           answer: row['Answer'])
  end
end

When(/^I click the question from the first scenario$/) do
  request answer_to_question_path(report_id: Report.current.id, text_component_id: @text_component.id, index: 1)
end

When(/^I click the question from the second scenario$/) do
  request answer_to_question_path(report_id: Report.current.id, text_component_id: @text_component.id, index: 2)
end

Given(/^we have these users in our database$/) do |table|
  table.hashes.each do |row|
    create(:user, name: row['Name'])
  end
end

When(/^I edit an existing text component$/) do
  @text_component = create(:text_component)
  edit_existing_text_component
end

When(/^I choose "([^"]*)" from the dropdown menu "([^"]*)"$/) do |option, select|
  select option, from: select
end

When(/I assign the text component to "([^"]*)"$/) do |assignee|
  find('.form-group.select', text: 'Assignee').click
  find('.choices__item', text: assignee).click
end

Then(/^I can see that Jane was assigned to the text component$/) do
  expect(page).to have_text 'Jane Doe'
end

Given(/^we have these text components:$/) do |table|
  table.hashes.each do |row|
    assignee = nil
    if row['Assignee'].present?
      assignee = User.find_by(name: row['Assignee']) || create(:user, name: row['Assignee'])
    else
      assignee = nil
    end

    report = Report.current
    if row['Report'].present?
      report = Report.find_by(name: row['Report']) || create(:report, name: row['Report'])
    end

    create(:text_component, report: report, heading: row['Text component'], assignee: assignee)
  end
end

Given(/^my user name is "([^"]*)"$/) do |name|
  @user = create(:user, name: name)
end

def log_in(user)
  visit '/users/sign_in'
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: user.password
  click_button 'Log in'
end

def log_out; end

Given(/^(?:I am logged in|I log in again)$/) do
  log_in(@user)
end

Then(/^I am on the text components page with only those assigned to me$/) do
  expect(page).to have_current_path("/reports/1/text_components?filter%5Bassignee_id%5D%5B%5D=#{@user.id}")
end

Given(/^I (?:am on|visit) the text components page$/) do
  visit report_text_components_path(Report.current)
end

When(/^I choose "([^"]*)" from "([^"]*)"$/) do |thing, options|
  select thing, from: options
end

Then(/^I see only the text component "([^"]*)"$/) do |heading|
  within('.item-table') do
    expect(page).to have_css('.item-table__item', count: 1)
    expect(page).to have_css('.item-table__item', text: heading)
  end
end

When(/^I filter by assignee "([^"]*)"$/) do |assignee_name|
  find('#filter-assignee').find('option', text: assignee_name).select_option
end

Given(/^I am on the text components show page because I just edited one$/) do
  text_component = create(:text_component)
  visit text_component_path(text_component)
end

Given(/^I landed on the "([^"]*)" page because I just edited that component$/) do |url|
  create(:text_component, id: url[/\d+$/])
  visit url
end

Then(/^the edit modal pops up, allowing me to correct mistakes$/) do
  expect(page).to have_text('Edit Text Component')
  fill_in 'text_component_heading', with: 'Another heading'
  click_on 'Update Text component'
  expect(page).to have_css('b', text: 'Another heading')
end

Given(/^I am on the signup page$/) do
  visit new_user_registration_path
end

Given(/^I fill in a valid email and a password$/) do
  fill_in 'Email', with: 'max@mustermann.de'
  fill_in 'user_password', with: 'password123'
  fill_in 'user_password_confirmation', with: 'password123'
end

Then(/^I see the error message in section "([^"]*)":$/) do |section, table|
  within_text_component_section(section) do
    table.transpose.hashes.each do |row|
      expect(find('.text-editor__field', text: row['Label'])).to have_text(row['Message'])
    end
  end
end

Then(/^I see error message telling me the user name can't be blank$/) do
  within('.form-group', text: 'Name') do
    expect(page).to have_text("can't be blank")
  end
end

Given(/^I am user "([^"]*)" and I am logged in$/) do |name|
  @user = create(:user, name: name)
  log_in(@user)
end

When(/^I edit my account and fill in my new name "([^"]*)"$/) do |name|
  visit edit_user_registration_path
  fill_in 'user_name', with: name
end

Then(/^I just need to confirm my password and click on "([^"]*)"$/) do |button|
  fill_in 'Current password', with: @user.password
  click_on button
end

Then(/^I can see, I'm called "([^"]*)" now$/) do |new_name|
  expect(page).to have_text(new_name)
end

Given(/^the current report is "([^"]*)"$/) do |name|
  current_report = Report.current
  current_report.name = name
  current_report.save!
end

Then(/^I can see the current report "([^"]*)" in the menu bar$/) do |report_name|
  expect(page).to have_css('option[selected]', text: report_name)
end

When(/^(?:when )?I choose "([^"]*)" to be the active report$/) do |report_name|
  switch_report(report_name)
end

def create_records(table, record_type)
  table.hashes.each do |row|
    report = Report.current
    if row['Report'].present?
      report = Report.find_by(name: row['Report']) || create(:report, name: row['Report'])
    end
    create(record_type, name: row[record_type.to_s.capitalize], report: report)
  end
end

Given(/^we have these sensors:$/) do |table|
  create_records(table, :sensor)
end

When(/^I (?:first )?navigate to the (present|preview|text component|sensor|trigger|event|settings) page$/) do |element|
  labels = {
    'present' => 'Live Report',
    'preview' => 'Preview Report',
    'text component' => 'Text Components',
    'sensor' => 'Sensors',
    'trigger' => 'Triggers',
    'event' => 'Events',
    'settings' => 'Report Settings'
  }
  url = find('.subnav__breadcrumb option', text: labels[element], visible: false)[:value]
  visit url
end

def check_table(string, count)
  within('table tbody') do
    expect(page).to have_css('tr', count: count)
    expect(page).to have_css('tr', text: string)
  end
end

Then(/^I see only the sensor "([^"]*)"$/) do |name|
  check_table(name, 1)
end

Given(/^we have these triggers:$/) do |table|
  create_records(table, :trigger)
end

Then(/^I see only the trigger "([^"]*)"$/) do |name|
  check_table(name, 1)
end

Given(/^I visit the present page of the current report$/) do
  visit present_report_path(Report.current)
end

def switch_report(report_name)
  url = find('.subnav__breadcrumb option', text: report_name, visible: false)[:value]
  visit url
end

When(/^switch to report "([^"]*)"$/) do |report_name|
  switch_report(report_name)
end

Then(/^I will see a different generated text as if I would switch to "([^"]*)"$/) do |report_name|
  expect(find('.live-report')).to have_text("It's about sensory data")
  switch_report(report_name)
  expect(find('.live-report')).to have_text('Robots are conquering the world')
end

Given(/^we have these text components for the chatbot:$/) do |table|
  table.hashes.each do |row|
    create(:text_component,
           main_part: row['Text component'],
           channels: [Channel.chatbot],
           report_id: row['report_id'],
           topic: (Topic.find_by(name: row['Topic']) || create(:topic, name: row['Topic'])))
  end
end

Given(/^we have these diary entries in our database:$/) do |table|
  table.hashes.each do |row|
    report_id = row['Report id']
    report = if report_id
               Report.find_by(id: report_id) || create(:report, id: report_id)
             else
               Report.current
             end
    create(:diary_entry, id: row['Id'], report: report, release: row['release'], moment: row['Moment'])
  end
end

Then(/^the JSON response should include the diary entries (\d+) and (\d+)$/) do |id1, id2|
  json_response = JSON.parse(last_response.body)
  expect(json_response.count).to eq 2
  expect(json_response[0]['id']).to eq id1.to_i
  expect(json_response[1]['id']).to eq id2.to_i
end

Then(/^the JSON response should include the diary entries (\d+), (\d+) and the live entry$/) do |id1, id2|
  json_response = JSON.parse(last_response.body)
  expect(json_response.count).to eq 3
  expect(json_response[0]['id']).to eq 0
  expect(json_response[1]['id']).to eq id1.to_i
  expect(json_response[2]['id']).to eq id2.to_i
end

Given(/^for that diary entry we have some text components and question answers$/) do
  report = Report.find(4711)
  create(:text_component, :with_question_answers, report: report)
  create(:text_component, report: report)
  create(:text_component, report: Report.current) # this should not go into the diary entry
end

When(/^I add a sensor reading for "(\d+)\ (\w+)\ (\d+) (\d+):(\d+)" with a calibrated value of (\d+)°C and an uncalibrated value of (\d+)°C$/) do |year, month, day, hour, minute, calibrated_value, uncalibrated_value|
  select year, from: 'sensor_reading_created_at_1i'
  select month, from: 'sensor_reading_created_at_2i'
  select day, from: 'sensor_reading_created_at_3i'
  select hour, from: 'sensor_reading_created_at_4i'
  select minute, from: 'sensor_reading_created_at_5i'
  fill_in 'Calibrated Value', with: calibrated_value
  fill_in 'Uncalibrated Value', with: uncalibrated_value
end

When(/^I delete the sensor reading with the id "([^"]*)"$/) do |sensor_reading_id|
  find('#sensor-reading-' + sensor_reading_id + ' a').click
end

Then(/^this sensor should have (\d+) new sensor reading$/) do |quantity|
  expect(@sensor.sensor_readings.count).to eq quantity.to_i
end

Given(/^I am composing some question answers for a text component$/) do
  text_component = create(:text_component, report: Report.current)
  edit_existing_text_component(text_component)
  within_text_component_section('Chatbot Q/A') do
    find('.btn', text: 'Add Question & Answer').click
  end
end

Given(/^I enter a question that is more than (\d+) characters long$/) do |count|
  within('.qa') do
    find('.question-input').set('a' * (count.to_i + 1))
  end
end

Given(/^I am on the landing page$/) do
  visit '/'
end

Then(/^the JSON response should be \(no matter in what order\):$/) do |json|
  expected = JSON.parse(json)
  actual = JSON.parse(last_response.body)
  actual['text_components'] = actual['text_components'].sort_by { |a| a['id'] }
  expect(actual).to eq(expected)
end

When(/^I create a new trigger$/) do
  visit new_report_trigger_path(Report.current)
end

Then(/^slider has a range from "([^"]*)" to "([^"]*)" with a step size of "([^"]*)"$/) do |min, max, step_size|
  range = all('.range__info').map(&:text)
  options = evaluate_script("$('.range').data('range').options")
  expect(range).to eq([min, max])
  expect(options['step'].to_s).to eq(step_size)
end

When(/^I edit the trigger "([^"]*)"$/) do |name|
  trigger = Trigger.find_by(name: name)
  visit edit_report_trigger_path(Report.current, trigger)
end

Then(/^the two bars of the slider are at position "([^"]*)" and "([^"]*)"$/) do |pos1, pos2|
  # Multirange adds a second slider input to create
  # the impression of a multirange slider.
  #
  # However, the value property on a multirange sliders
  # isn't fully polyfilled in all browsers (which seems
  # to be the case with PhantomJS)
  #
  # See Limitations: https://leaverou.github.io/multirange/
  #
  # Due to this we need to get the value from the two sliders
  # (the original one and the "ghost" slider) manually.

  value1 = evaluate_script("$('.range__input.original').val()")
  value2 = evaluate_script("$('.range__input.ghost').val()")

  expect(value1).to eq(pos1)
  expect(value2).to eq(pos2)
end

When(/^I take some notes for this text component:/) do |notes|
  find('.notes-field__input').set(notes)
end

Then(/^I should see in section "([^"]*)":$/) do |section, string|
  within_text_component_section(section) do
    non_visible_text = find('.notes-field').text(:all)
    expect(string).not_to be_empty
    expect(non_visible_text).to include(string)
  end
end

When(/^I fill in these form fields in section "([^"]*)":$/) do |header, table|
  table.raw.each do |row|
    within_text_component_section(header) do
      fill_in row[0], with: row[1]
    end
  end
end

Given(/^there is an event$/) do
  @event = create(:event)
end

Given(/^the event was started$/) do
  @event.start Time.now
end

When(/^I edit the event$/) do
  visit edit_event_path(@event)
end

When(/^I wait for (\d+) years$/) do |some|
  Timecop.travel some.to_i.years.from_now
end

Then(/^a new event activation is in the database which took (\d+) years$/) do |years|
  expect(page).to have_css('.btn.start-event-button')
  duration = Event::Activation.last.duration
  expect(duration).to be > years.to_i * 365 * 24 * 60 * 60
end

Then(/^(?:I see |now )?the event "([^"]*)"$/) do |state|
  expect(page).to have_text(state)
end

Given(/^the event was active three times in the past$/) do
  create(:event_activation, event: @event, id: 23, started_at: '2017-08-04  16:19:13 UTC', ended_at: '2017-08-04  16:19:15 UTC')
  create(:event_activation, event: @event, id: 24, started_at: '2017-08-04  16:19:16 UTC', ended_at: '2017-08-04  16:19:17 UTC')
  create(:event_activation, event: @event, id: 25, started_at: '2017-08-04  16:19:18 UTC', ended_at: '2017-08-04  16:19:19 UTC')
end

Then(/^I can see the history of the event, it looks like this:$/) do |table|
  table.hashes.each do |row|
    within('tr', text: row['Id']) do
      expect(page).to have_text(row['Started at'])
      expect(page).to have_text(row['Ended at'])
    end
  end
end

Then(/^there is (\d+) trigger and (\d+) text component more in the database$/) do |count_triggers, count_text_components|
  expect(Trigger.count).to eq(count_triggers.to_i)
  expect(TextComponent.count).to eq(count_text_components.to_i)
end

Given(/^I visit the new text component page$/) do
  visit new_report_text_component_path(Report.current)
end

Given(/^I want to start and stop events from the event index page$/) do
  visit events_path(Report.current)
end

When(/^the event is active/) do
  expect(page).to have_css('.btn.stop-event-button')
  expect(@event).to be_active
end

When(/^the event is (?:not active|inactive)$/) do
  expect(page).to have_css('.btn.start-event-button')
  expect(@event).not_to be_active
end

Then(/^(\d+) event activations are in the database$/) do |count|
  expect(Event::Activation.count).to eq count.to_i
end

Then(/^I am back on the events index page$/) do
  expect(page).to have_css('option[selected]', text: 'Events', visible: false)
end

Given(/^we have these sensor readings for sensor (\d+) in our database:$/) do |sensor_id, table|
  sensor = create(:sensor, id: sensor_id, report: Report.current)
  @sensor = sensor
  table.hashes.each do |row|
    annotation = row['Annotation']
    annotation = nil if annotation.blank?
    create(:sensor_reading, sensor: sensor,
                            id: row['Id'],
                            created_at: row['Created at'],
                            calibrated_value: row['Calibrated value'],
                            uncalibrated_value: row['Uncalibrated value'],
                            annotation: annotation,
                            release: row['Release'])
  end
end

Given(/^we have these sensor readings for sensor "([^"]*)" in our database:$/) do |sensor_name, table|
  sensor = create(:sensor, name: sensor_name, report: Report.current)
  table.hashes.each do |row|
    create(:sensor_reading, sensor: sensor,
                            id: row['Id'],
                            created_at: row['Created at'],
                            calibrated_value: row['Calibrated value'],
                            uncalibrated_value: row['Uncalibrated value'],
                            release: row['Release'])
  end
end

When(/^notice that we OVERRIDE the given sensor id (\d+) here$/) do |arg1|
  # just documentation
end

Given(/^a humidity sensor with some sensor readings$/) do
  @diary_entry = DiaryEntry.first
  @humidity_sensor = create(:sensor,
                            name: 'Humidity Sensor 1',
                            sensor_type: create(:sensor_type, property: 'humidity', unit: '%'))
  create(:sensor_reading,
         created_at: (@diary_entry.moment - 2.weeks),
         sensor: @humidity_sensor,
         calibrated_value: 50)
end

Given(/^for this diary entry we have an active text component:$/) do |text|
  trigger = create(:trigger, report: Report.current)
  create(:condition,
         sensor: @humidity_sensor,
         trigger: trigger,
         from: 0,
         to: 100)
  @text_component = create(:text_component,
                           report: Report.current,
                           channels: [Channel.sensorstory],
                           main_part: text,
                           triggers: [trigger])
end

Given(/^the sensor live report started on "([^"]*)"$/) do |date|
  @report = Report.current
  @report.start_date = date
  @report.save
end

Given(/^we have these diary entries for the report:$/) do |table|
  table.hashes.each do |row|
    create(:diary_entry, id: row['Id'], moment: row['Moment'], report: @report)
  end
end

When(/^I visit "([^"]*)"$/) do |url|
  visit url
end

When(/^in section Image I choose my file "([^"]*)" for upload$/) do |_arg1|
  within_text_component_section('Image') do
    attach_file('Upload image', Rails.root + 'fixtures/cow.jpg')
  end
end

Then(/^the text component image url starts with$/) do |string|
  @text_component.reload
  expect(@text_component.image.url).to start_with(string)
end

When(/^I submit the form and upload the image$/) do
  click_on 'Update Text component'
end

Given(/^the current date is "([^"]*)"$/) do |date|
  Timecop.travel(Time.parse(date))
end

Given(/^I have a text component that is active right now$/) do
  create(:text_component, report: Report.find(4711), main_part: 'I am in!')
end

When(/^I follow the URL of the live entry \(id == 0\)$/) do
  json_response = JSON.parse(last_response.body)
  expect(json_response[0]['id']).to eq 0
  request json_response[0]['url'], method: :get
end

Then(/^the JSON response should include the active text component$/) do
  json_response = JSON.parse(last_response.body)
  expect(json_response['text_components'][0]['main_part']).to eq('I am in!')
end

When(/^I edit an existing text component with an image$/) do
  @text_component = create(:text_component)
  @text_component.image = File.new('fixtures/cow.jpg')
  edit_existing_text_component
end

When(/^in section Image I tick the checkbox to delete the image$/) do
  within_text_component_section('Image') do
    check 'text_component[delete_image]'
  end
end

Then(/^the text component image url is empty or shows the standard image missing url$/) do
  @text_component.reload
  expect(@text_component.image.url).to eq('/images/original/missing.png')
end

When(/^I submit the form and delete the image$/) do
  click_on 'Update Text component'
end

Then('the annotation was successfully saved to the database and I can see it on the page') do
  expect(page).to have_text('Sensor reading was successfully updated.')
  expect(page.find('input[value="Sudden increase"]')).to be_present
  expect(Sensor::Reading.find_by(annotation: 'Sudden increase'))
end

When('annotate sensor reading {int} with {string}') do |int, annotation|
  within("#sensor-reading-#{int}") do
    fill_in 'sensor_reading_annotation', with: annotation
    click_on 'Annotate'
  end
end
