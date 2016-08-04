@76
Feature: Add timeliness constraint
  As a journalist
  I want to define that a text component will be triggered only for a recent sensor reading
  Because e.g. a loud noise from five days ago is not relevant anymore

  Background:
    Given I have a temperature sensor called "LoudNoises"
    And I have a text component with the heading "BOOM! What was that?"

  Scenario: Add a timeliness constraint to a text component
    When I visit the edit page of this text component
    And I set the component to trigger only for recent data within the last 3 hours
    And I click on "Update"
    Then this text component has a timeliness constraint of 3 hours
