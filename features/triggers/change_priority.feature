Feature: Text components: Priorities
  As a journalist
  I want to store priorities for triggers
  So the sensor.bot can make a selection if not all triggers fit into a report


  Background:
    Given there is a sensor live report

  Scenario: Edit Trigger Priority
    Given I have a trigger with the name "Very Important"
    When I visit the landing page
    And I click on "Triggers" in my dashboard
    And I click on "Edit" to change the priority
    And I select "high" from the priorities
    And I click on "Update"
    Then my heading has become very important
