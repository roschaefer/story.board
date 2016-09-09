
When(/^I visit the landing page/) do
  page.reset!
  visit root_path
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
  visit new_sensor_path
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

Given(/^I have a text component with the heading "([^"]*)"$/) do |heading|
  @text_component = create(:text_component, heading: heading)
end

When(/^I visit the edit page of this text component$/) do
  visit edit_text_component_path(@text_component)
end

When(/^I add a condition$/) do
  click_on 'add condition'
  expect(page).to have_text('remove condition') # wait until it's there
end

When(/^I choose the sensor "([^"]*)" to trigger this text component$/) do |sensor|
  select sensor, from: 'Sensor'
end

When(/^I define a range from "([^"]*)" to "([^"]*)" to cover the relevant values$/) do |arg1, arg2|
  fill_in 'From', with: arg1
  fill_in 'To',   with: arg2
end

When(/^I click on update$/) do
  click_on 'Update'
  expect(page).to have_text('Edit') # wait until saved
end

Then(/^the text component is connected to the ([^"]*) sensor$/) do |property|
  @text_component.reload
  expect(@text_component.sensors).not_to be_empty
  expect(@text_component.sensors.first.sensor_type.property).to eq property.capitalize
end

Then(/^the condition has relevant values from (\d+) to (\d+)$/) do |arg1, arg2|
  @text_component.reload
  expect(@text_component.conditions.first.from).to eq arg1.to_i
  expect(@text_component.conditions.first.to).to   eq arg2.to_i
end

Given(/^this sensor just measured a .* of (\d+)°C$/) do |value|
  create(:sensor_reading, sensor: @sensor, calibrated_value: value)
end

Given(/^I prepared a text component for this sensor with this introduction:$/) do |introduction|
  @text_component = create(:text_component, report: Report.current, introduction: introduction)
  create(:condition, text_component: @text_component, sensor: @sensor)
end

Given(/^this text component should trigger for a value between (\d+)°C and (\d+)°C$/) do |from, to|
  expect(@text_component.conditions.length).to eq 1 # sanity check - just in case
  condition = @text_component.conditions.first
  condition.from = from
  condition.to = to
  condition.save!
end

Given(/^for my current report I have these text components prepared:$/) do |table|
  table.hashes.each do |row|
    component = create(:text_component, report: Report.current, main_part: row['Text Component'])
    sensor = create(:sensor, name: row['Sensor'], report: Report.current)
    create(:condition, sensor: sensor, text_component: component, from: row['From'], to: row['To'])
  end
end

Given(/^for my sensors I have these text components prepared:$/) do |table|
  table.hashes.each do |row|
    component = create(:text_component, report: Report.current, main_part: row['Text Component'], timeliness_constraint: row['Timeliness'])
    sensor = Sensor.find_by name: row['Sensor']
    create(:condition, sensor: sensor, text_component: component, from: row['From'], to: row['To'])
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

Given(/^I am the journalist$/) do
  # NOP: currently no authentication implemented
end

Given(/^there is a sensor live report/) do
  create(:report)
end

Given(/^I visit the settings page of the current report$/) do
  visit edit_report_path(Report.current)
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
  create(:report, name: name)
end

When(/^I select "([^"]*)" from the settings in my dashboard$/) do |name|
  click_on 'Settings'
  click_on name
end

When(/^I click on "([^"]*)"/) do |thing|
  click_on thing
end

When(/^I type in some text for (.*)$/) do |things|
  things.split(',').each do |thing|
    fill_in thing.strip, with: 'Blablablabla'
  end
end

Then(/^I have a new text component for my live report in the database$/) do
  current_report = Report.current
  expect(current_report.text_components).not_to be_empty
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
  visit sensor_path(@sensor)
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
  choose selection
end

Then(/^my heading has become very important$/) do
  @text_component.reload
  expect(@text_component.priority).to eq 'high'
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

Then(/^this text component has a timeliness constraint of (\d+) hours$/) do |hours|
  @text_component.reload
  expect(@text_component.timeliness_constraint).to eq hours.to_i
end

Given(/^I see the (?:current|new)? live report:$/) do |string|
  expect(page).to have_css('.live-report')
  expect(find('.live-report')).to have_text string
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
  expect(page).to have_css('.dropdown-menu')
  expect(find('.dropdown-menu')).to have_text @report_name
end

Given(/^there is an active text component with the following main part:$/) do |main_part|
  create(:text_component, main_part: main_part, report: Report.current)
end

Given(/^I have these active text components:$/) do |table|
  table.hashes.each do |row|
    create(:text_component, {
      priority: row['Priority'],
      heading: row['Heading'],
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

Given(/^have some text components prepared that will trigger on a particular event$/) do |table|
  table.hashes.each do |row|
    event = Event.find_by(name: row['Event'])
    create(:text_component, report: Report.current, main_part: row['Main part'], events: [event])
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


Given(/^there is a medium prioritized, active component with a really long text$/) do
  main_part = "Blaaa" + 500.times.collect{ "a"}.join + "aaahhhh!"
  create(:text_component,
         report: Report.current,
         main_part: main_part,
         priority: :medium)
end

Then(/^I can see the main heading:$/) do |string|
  expect(page).to have_css('.main-heading', text: string)
end

Then(/^I can see a subheading:$/) do |string|
  expect(page).to have_css('.sub-heading', text: string)
end

Given(/^my reporter box has the id "([^"]*)"$/) do |id|
  # as long as we don't have the box, fake it
  @box_id = id
end

Given(/^there is an actor that controls a light in my reporter box$/) do
  @actor = create(:actor, name: "Light")
end

When(/^I visit the page of this actor$/) do
  visit actor_path(@actor)
end

Then(/^a request will be sent to this url:$/) do |url|
  last_command = Command.last
  expect(last_command.actor.url).to eq url
end

Then(/^the request payload contains this data:$/) do |string|
  last_command = Command.last
  expect(last_command.payload).to eq string
end
