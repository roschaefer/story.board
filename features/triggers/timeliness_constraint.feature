@76
Feature: Add validity period
  As a journalist
  I want to define that a trigger will be triggered only for a recent sensor reading
  Because e.g. a loud noise from five days ago is not relevant anymore

  Background:
    Given I am the journalist
    And I have a temperature sensor called "LoudNoises"
    And I have a trigger with the name "BOOM! What was that?"

  Scenario: Add a validity period to a trigger
    When I visit the edit page of this trigger
    And I set the component to trigger only for recent data within the last 3 hours
    And I click on "Update"
    Then this trigger has a validity period of 3 hours
