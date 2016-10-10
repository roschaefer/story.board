@76
Feature: Add timeliness constraint
  As a journalist
  I want to define that a trigger will be triggered only for a recent sensor reading
  Because e.g. a loud noise from five days ago is not relevant anymore

  Background:
    Given I have a temperature sensor called "LoudNoises"
    And I have a trigger with the heading "BOOM! What was that?"

  Scenario: Add a timeliness constraint to a trigger
    When I visit the edit page of this trigger
    And I set the component to trigger only for recent data within the last 3 hours
    And I click on "Update"
    Then this trigger has a timeliness constraint of 3 hours
