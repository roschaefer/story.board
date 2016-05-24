
When(/^I visit the landing page$/) do
  visit root_path
end

Then(/^I should see:$/) do |string|
  expect(page).to have_text string
end

Given(/^I have a sensor called "([^"]*)"$/) do |name|
  create :sensor, :name => name
end

Given(/^I have a sensor with id (\d+)$/) do |arg|
  create :sensor, :id => arg.to_i
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
  create(:sensor_type, :property => property, :unit => unit)
end

When(/^I want to create a new sensor/) do
  visit new_sensor_path
  fill_in :sensor_name, :with => "SensorXYZ"
end

When(/^I select the sensor type "([^"]*)"$/) do |type|
  select type, :from => "sensor_sensor_type_id"
end

When(/^I confirm the dialog$/) do
  click_on "Create"
end

Then(/^I have a new sensor in my databas$/) do
  expect(Sensor.count).to eq 1
end

