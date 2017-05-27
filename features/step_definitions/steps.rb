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

Given(/^I have a sensor with id (\d+)$/) do |arg|
  create :sensor, id: arg.to_i
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
  click_on 'Create'
end

Then(/^I have a new sensor in my database$/) do
  expect(Sensor.count).to eq 1
end

Given(/^I have a ([^"]*) sensor called "([^"]*)"$/) do |property, name|
  temperature_type = create(:sensor_type, property: property.capitalize)
  create :sensor, name: name, sensor_type: temperature_type
end

Given(/^I have a trigger with the name "([^"]*)"$/) do |name|
  @trigger = create(:trigger, name: name)
end

When(/^I visit the edit page of this trigger$/) do
  visit edit_report_trigger_path(Report.current, @trigger)
end

When(/^I add a condition$/) do
  find('button', text: /Add sensor/).click
  expect(page).to have_text('Remove sensor') # wait until it's there
end

When(/^I choose the sensor "([^"]*)" to trigger this trigger$/) do |sensor|
  find('.choose_sensor').select sensor
end

When(/^I define a range from "([^"]*)" to "([^"]*)" to cover the relevant values$/) do |arg1, arg2|
  first('.range-slider-min-value', visible: false).set(arg1)
  first('.range-slider-max-value', visible: false).set(arg2)
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

Then(/^the condition has relevant values from (\d+) to (\d+)$/) do |arg1, arg2|
  @trigger.reload
  expect(@trigger.conditions.first.from).to eq arg1.to_i
  expect(@trigger.conditions.first.to).to   eq arg2.to_i
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
                     name: row['Trigger'],
                     )
    sensor = create(:sensor, name: row['Sensor'], report: Report.current)
    create(:condition, sensor: sensor, trigger: trigger, from: row['From'], to: row['To'])
  end
end

Given(/^for my sensors I have these triggers prepared:$/) do |table|
  table.hashes.each do |row|
    trigger = create(:trigger, report: Report.current, name: row['Trigger'], timeliness_constraint: row['Timeliness'])
    sensor = Sensor.find_by name: row['Sensor']
    create(:condition, sensor: sensor, trigger: trigger, from: row['From'], to: row['To'])
  end
end

Given(/^the latest sensor data looks like this:$/) do |table|
  table.hashes.each do |row|
    sensor = Sensor.find_by(name: row['Sensor'])
    reading_attr = { sensor: sensor, calibrated_value: row['Calibrated Value'].to_i}
    reading = create(:sensor_reading, reading_attr)
    created_at_code = row['Created at']
    if created_at_code
      reading.created_at = eval(created_at_code.downcase.gsub(' ','.'))
      reading.save!
    end
  end
end

Then(/^I should NOT see:$/) do |string|
  expect(page).not_to have_content(string)
end

Given(/^I am (?:a|the) (?:journalist|service team member)/) do
  @user ||= create(:user)
  log_in @user
end

Given(/^there is a sensor live report/) do
  expect(Report.current).to be_present
  expect(Channel.sensorstory).to be_present
end

When(/^I choose "([^"]*)" to be the start date for the experiment$/) do |start_date|
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

When(/^I select "([^"]*)" from the settings in my dashboard$/) do |name|
  click_on 'Reports'
  click_on name
end

When(/^I click on "([^"]*)"/) do |thing|
  click_on thing
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

Then(/^this sensor should have (\d+) new sensor readings as fake data$/) do |quantity|
  expect(@sensor.sensor_readings.fake.count).to eq quantity.to_i
end

Then(/^I should see some generated entries in the sensor readings table$/) do
  within '#sensor-readings-table-fake' do
    expect(page).to have_css('.sensor-reading-row')
  end
end

Given(/^I have fake and real sensor readings for sensor "([^"]*)"$/) do |name|
  @sensor = Sensor.find_by(name: name)
  Sensor::Reading.transaction do
    7.times { create(:sensor_reading, sensor: @sensor, intention: :fake) }
    5.times { create(:sensor_reading, sensor: @sensor, intention: :real) }
  end
end

When(/^I (?:see|visit) the page of (?:this|that) sensor$/) do
  visit report_sensor_path(Report.current, @sensor)
end

Then(/^fake and real data are distinguishable$/) do
  within '#sensor-readings-table-fake' do
    expect(page).to have_css('.sensor-reading-row', count: 7)
  end
  within '#sensor-readings-table-real' do
    expect(page).to have_css('.sensor-reading-row', count: 5)
  end
end

Given(/^there is some generated test data:$/) do |table|
  ActiveRecord::Base.transaction do
    table.hashes.each do |row|
      sensor = Sensor.find_by(name: row['Sensor'])
      create(:sensor_reading, sensor: sensor, calibrated_value: row['Calibrated Value'].to_i, intention: :fake)
    end
  end
end

Then(/^I can read this text:$/) do |string|
  string.split('[...]').each do |part|
    expect(page).to have_text(part)
  end
end

Given(/^I have a sensor with a I2C address "([^"]*)"$/) do |address|
  @sensor = create(:sensor, :address => address)
end

Then(/^now the sensor has a new sensor reading in the database$/) do
  expect(@sensor.sensor_readings.count).to eq 1
end

When(/^I choose an address "([^"]*)"$/) do |address|
  fill_in "Address", :with => address
end

When(/^by the way, the "([^"]*)" attribute above is a string$/) do |arg1|
  # only documentation
end

When(/^I select "([^"]*)" from the priorities$/) do |selection|
  select selection, from: 'trigger_priority'
end

Then(/^my heading has become very important$/) do
  @trigger.reload
  expect(@trigger.priority).to eq 'high'
end

Given(/^I have (\d+) entries for a sensor in my database$/) do |quantity|
  Sensor.transaction do
    @sensor = create(:sensor)
    Sensor::Reading.transaction do
      quantity.to_i.times do
        create(:sensor_reading, :sensor => @sensor)
      end
    end
  end
end

Then(/^I see only (\d+) sensor readings$/) do |times|
  expect(page).to have_css('.sensor-reading-row', count: times)
end

Then(/^the first row is the most recent sensor reading$/) do
  id = page.first('td').text
  first_row = Sensor::Reading.find(id)
  most_recent = Sensor::Reading.order(:created_at).last
  expect(first_row.id).to eq most_recent.id
end

Given(/^I have these sensors and sensor types in my database$/) do |table|
  table.hashes.each do |row|
    sensor_type = create(:sensor_type, property: row['Property'], unit: row['Unit'])
    create(:sensor,
           id: row['SensorID'].to_i,
           name: row['Sensor'],
           sensor_type: sensor_type,
           report: Report.current)
  end
end

When(/^I add a video URL to the report$/) do
  click_on "Edit"
  @url = '//example.com/embedded/live/example?autoplay=1'
  fill_in "Video URL", with: @url
  click_on "Update Report"
end

Then(/^I can watch a video stream that points to this url$/) do
  expect(page).to have_css('iframe')
  expect(find('iframe')['src']).to eq @url
end

When(/^I set the component to trigger only for recent data within the last (\d+) hours$/) do |hours|
  fill_in "Timeliness constraint", with: hours
end

Then(/^this trigger has a timeliness constraint of (\d+) hours$/) do |hours|
  @trigger.reload
  expect(@trigger.timeliness_constraint).to eq hours.to_i
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
  schedule = Whenever::Test::Schedule.new
  task = schedule.jobs[:rake].first[:task]
  Rake::Task[task].invoke
end

When(/^I change the name of the report to "([^"]*)"$/) do |name|
  @report_name = name
  fill_in 'Name', with: @report_name
end

Then(/^I see the new name in the settings menu above$/) do
  expect(page).to have_css('.dropdown.settings')
  expect(find('.dropdown.settings .dropdown-menu')).to have_text @report_name
end

Given(/^there is a triggered text component with the following main part:$/) do |main_part|
  create(:text_component, main_part: main_part, report: Report.current)
end

Given(/^I have these active triggers:$/) do |table|
  table.hashes.each do |row|
    create(:trigger, :active, {
      name: row['Trigger'],
      report: Report.current
    })
  end
end

Then(/^I should see only one of the following:$/) do |string|
  parts = string.split('[OR]').collect {|p| p.strip }
  seen_parts = parts.select {|p| page.text.include?(p) }
  expect(seen_parts.length).to eq 1
end

Given(/^I have these custom variables for my report:$/) do |table|
  table.hashes.each do |row|
    key, value = row['Key'], row['Value']
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

Given(/^I have these events in my database$/) do |table|
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
  event.happened_at = DateTime.parse(date)
  event.save
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
  main_part = "Blaaa" + 500.times.collect{ "a"}.join + "aaahhhh!"
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
  payload = "args=" + @command.argument
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

When(/^I add (?:a|another)? trigger and choose "([^"]*)"$/) do |trigger|
  unless page.has_css?('.dropdown-menu.inner')
    within(".text_component_triggers") do
      find('.bootstrap-select').click
    end
    expect(page).to have_css('.dropdown-menu.inner')
  end
  find('li', text: trigger).click
end

Then(/^the text component is connected to both triggers$/) do
  expect(@text_component.triggers.count).to eq 2
end


Given(/^I have these text components with the corresponding schedule in my database:$/) do |table|
  table.hashes.each do |row|
    create(:text_component,
           main_part: row['Text component'],
           report: Report.current,
           from_day: row['From day'],
           to_day: row['To day']
          )
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
         sensor_type: create(:sensor_type, property: property)
        )

end

When(/^I visit its sensor page$/) do
  visit report_sensor_path(Report.current, @sensor)
end

When(/^all subsequent sensor readings will be intercepted for a while$/) do
  # send and accept JSON
  header 'Accept', "application/json"
  header 'Content-Type', "application/json"

  expect(@sensor.sensor_readings).to be_empty
  @values = [3,5,7,11,13,17].shuffle
  @values.each do |value|
    input = {
      "sensor_id": @sensor.id,
      "calibrated_value": value,
      "uncalibrated_value": value,
    }.to_json
    request '/sensor_readings', { method: :post, input: input }
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
  expect(page).to have_text("17")
  expect(page).to have_text("3")
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

Given(/^it's (\d+)am$/) do |hours|
  Timecop.travel(Time.now.beginning_of_day + hours.to_i.hours)
end

When(/^I wait for (\d+) hours$/) do |hours|
  Timecop.travel hours.to_i.hours.from_now
end

Given(/^some triggers are active at certain hours:$/) do |table|
  table.hashes.each do |row|
    create(:trigger,
           report: Report.current,
           name: row['Trigger'],
           from_hour: row['From'],
           to_hour: row['To'],
          )
  end
end

def edit_existing_text_component
  visit report_text_components_path(Report.current)
  within('tr', text: @text_component.heading) do
    click_on 'Edit'
  end
  expect(page).to have_text('Editing text component')
end

When(/^I edit this text component$/) do
  edit_existing_text_component
end

When(/^I update the text component$/) do
  # close choose trigger dropdown
  if page.has_css?('.dropdown-menu.inner')
    within(".text_component_triggers") do
      find('.bootstrap-select').click
    end
    expect(page).not_to have_css('.dropdown-menu.inner')
  end

  within("#edit_text_component_#{@text_component.id}") do
    click_on 'Update'
  end

  expect(page).to have_text('Text component was successfully updated.')
end

Given(/^our sensor live report has a channel "([^"]*)"$/) do |name|
  @channel =  Channel.find_by(name: name)
  unless @channel
    @channel = create(:channel, name: name, report: Report.current)
  end
end

Given(/^a topic "([^"]*)"$/) do |name|
  @topic = create(:topic, name: name)
end

Given(/^we created a text component for it that is active right now$/) do
  create(
    :text_component,
    :active,
    main_part: "Got milk?",
    channels: [@channel],
    topic: @topic,
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
  @text_component = create(:text_component, heading: "easy one", main_part: @easy, report: Report.current)
end

When(/^I edit the easier text component$/) do
  visit report_text_components_path(Report.current)
  within('tr', text: @text_component.heading) do
    click_on 'Edit'
  end
  expect(page).to have_text('Editing text component')
end

When(/^choose "([^"]*)" as a channel$/) do |channel|
  within("#edit_text_component_#{@text_component.id}") do
    select channel, from: 'text_component_channel_ids'
  end
end

When(/^unslect "([^"]*)" as a channel$/) do |channel|
  within("#edit_text_component_#{@text_component.id}") do
    unselect channel, from: 'text_component_channel_ids'
  end
end

Then(/^the easier text will go into the channel "([^"]*)"$/) do |channel_name|
  channel = Channel.find_by(name: channel_name)
  visit edit_channel_path(channel)
  expect(@easy).not_to be_empty
  expect(page).to have_text(@easy)
end

Then(/^the easier text will not appear in main story$/) do
  visit "/reports/current"
  expect(page).not_to have_text(@easy)
end

Given(/^this text component has these questions and answers already:$/) do |table|
  @question_answers = []
  table.hashes.each do |row|
    question_answer = create(:question_answer, text_component: @text_component, question: row['Question'], answer: row['Answer'])
    @question_answers << question_answer
  end
end

When(/^I fill the empty question with:$/) do |string|
  @question_text = string
  find(:fillable_field, 'Question', with: '').set(@question_text)
end

When(/^I enter the missing answer:$/) do |string|
  @answer_text = string
  find(:fillable_field, 'Answer', with: '').set(@answer_text)
end

Then(/^a new question\/answer was added to the database$/) do
  expect(page).to have_text('Text component was successfully updated.')
  @text_component.reload
  qa = (@text_component.question_answers.last)
  expect(@question_answers).not_to include(qa)
  expect(qa.question).to be_present
  expect(qa.answer).to be_present
end

Then(/^I can see the new question and the answer on the page$/) do
  expect(@question_text).to be_present
  expect(@answer_text).to be_present
  expect(page).to have_text(@question_text)
  expect(page).to have_text(@answer_text)
end

When(/^I click the "([^"]*)" button$/) do |label|
  click_button(label)
end

When(/^two more input fields pop up, one for the new question and one for the new answer$/) do
  expect(page).to have_field('Question', with: '', count: 1)
  expect(page).to have_field('Answer', with: '', count: 1)
end

Given(/^we have an active text component with these question\/answers:$/) do |table|
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

Given(/^we have different text components, each having question\/answers$/) do
  # sophisticated test set up
  create(:important_text_component,
         heading: 'News from Bertha the cow',
         introduction: '',
         main_part: 'I gave eleven liters of milk today.',
         closing: '',
         question_answers: [
          build(:question_answer, question: 'Is this a lot?', answer: 'I would say, that\'s quite a lot.'),
          build(:question_answer, question: 'Shall it become more?', answer: 'I hope for it.')
          ]
        )
  create(:text_component,
         heading: 'This heading will not be visible',
         introduction: '',
         main_part: 'It was hot and stuffy in the stable.',
         closing: 'I hope it gets colder tomorrow.',
        question_answers: [build(:question_answer, question: 'How hot was it?', answer: 'Unbearable.')]
        )
end

def check_expanding_report(string)
  parts = string.split('[...]')
  parts.each do |part|
    expect(page).to have_text(part.gsub("\n", ' '))
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

Given(/^we have an active text component for that topic with these question\/answers:$/) do |table|
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

Given(/^we have an active text component with the id (\d+) for that topic with these question\/answers:$/) do |id, table|
  @text_component = create(:text_component,
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
  request answer_to_question_path(text_component_id: @text_component.id, index: 1)
end

When(/^I click the question from the second scenario$/) do
  request answer_to_question_path(text_component_id: @text_component.id, index: 2)
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

Then(/^I can see that Jane was assigned to the text component$/) do
  within '.assignee' do
    expect(page).to have_text 'Jane Doe'
  end
end

Given(/^we have these text components:$/) do |table|
  table.hashes.each do |row|
    assignee = nil
    if row['Assignee'].present?
<<<<<<< HEAD
      assignee = User.find_by(name: row['Assignee']) || create(:user, name: row['Assignee'])
    else
      assignee = nil
=======
      assignee = User.find_by(email: row['Assignee']) || create(:user, email: row['Assignee'])
>>>>>>> plant cucumber for #348
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
  fill_in "user_email", :with => user.email
  fill_in "user_password", :with => user.password
  click_button "Log in"
end

Given(/^I am logged in$/) do
  log_in(@user)
end

When(/^I click on the dropdown menu with my user account on the top right$/) do
  click_on 'user-menu'
end

Then(/^I am on the text components page with only those assigned to me$/) do
  expect(page).to have_current_path("/reports/1/text_components?filter%5Bassignee_id%5D%5B%5D=#{@user.id}")
end

Given(/^I am on the text components page$/) do
  visit report_text_components_path(Report.current)
end

When(/^I choose "([^"]*)" from "([^"]*)"$/) do |thing, options|
  select thing, from: options
end

Then(/^I see only the text component "([^"]*)"$/) do |heading|
  within('table.text-components-table') do
    expect(page).to have_css('tr.text-component', count: 1)
    expect(page).to have_css('tr.text-component', text: heading)
  end
end

When(/^I filter by assignee "([^"]*)"$/) do |assignee_name|
  click_on '...choose a user'
  find('li', text: assignee_name).click
  click_on 'Filter'
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
  expect(page).to have_text('Editing text component')
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

Then(/^I see the error message: "([^"]*)"$/) do |error_message|
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
  expect(page).to have_css('#current_report', text: report_name)
end

When(/^I choose "([^"]*)" to be the active report$/) do |report_name|
  click_on 'current_report'
  find('.present-report', text: report_name).click
end

Given(/^I(?: first)? navigate to the text component page$/) do
  expect(page).to have_css('a', text: 'Text Components')
  click_on 'Text Components'
end
