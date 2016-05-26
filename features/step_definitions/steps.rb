
When(/^I visit the landing page$/) do
  visit root_path
end

Then(/^I should see:$/) do |string|
  expect(page).to have_text string
end

Given(/^I have a sensor called "([^"]*)"$/) do |name|
  @sensor = create(:sensor, :name => name)
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

Then(/^I have a new sensor in my database$/) do
  expect(Sensor.count).to eq 1
end

Given(/^I have a ([^"]*) sensor called "([^"]*)"$/) do |property, name|
  temperature_type = create(:sensor_type, :property => property.capitalize)
  create :sensor, :name => name, :sensor_type => temperature_type
end

Given(/^I have a text component with the heading "([^"]*)"$/) do |heading|
  @text_component = create(:text_component, :heading => heading)
end

When(/^I visit the edit page of this text component$/) do
  visit edit_text_component_path(@text_component)
end

When(/^I add a condition$/) do
  click_on "add condition"
  expect(page).to have_text("remove condition") # wait until it's there
end

When(/^I choose the sensor "([^"]*)" to trigger this text component$/) do |sensor|
  select sensor, :from => "Sensor"
end

When(/^I define a range from "([^"]*)" to "([^"]*)" to cover the relevant values$/) do |arg1, arg2|
  fill_in "From", :with => arg1
  fill_in "To",   :with => arg2
end

When(/^I click on update$/) do
  click_on "Update"
  expect(page).to have_text("Edit") # wait until saved
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
  create(:sensor_reading, :sensor => @sensor, :calibrated_value => value)
end

Given(/^I prepared a text component for this sensor with this introduction:$/) do |introduction|
  @text_component = create(:text_component, :introduction => introduction)
  create(:condition, :text_component => @text_component, :sensor => @sensor)
end

Given(/^this text component should trigger for a value between (\d+)°C and (\d+)°C$/) do |from, to|
  expect(@text_component.conditions.length).to eq 1 # sanity check - just in case
  condition = @text_component.conditions.first
  condition.from = from
  condition.to = to
  condition.save!
end

