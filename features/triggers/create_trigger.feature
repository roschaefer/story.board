Feature: Create Trigger
  As a journalist
  I want to create new triggers for my live report
  To control the input for the text generator


  Background:
    Given there is a sensor live report
    And I am the journalist

  Scenario:
    When I visit the landing page
    And I click on "Triggers" in my dashboard
    And I click on "Add new trigger" to create a new trigger
    And I type in a name
    And I confirm the dialog
    Then I have a new trigger for my live report in the database
