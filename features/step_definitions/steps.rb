
When(/^I visit the landing page$/) do
  visit root_path
end

Then(/^I should see:$/) do |string|
  expect(page).to have_text string
end

