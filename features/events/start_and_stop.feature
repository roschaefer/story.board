Feature: Start and stop events
  As a reporter
  I want to manually start and stop events
  In order to define the range when the event happend

  Background:
    Given I am the journalist
    And there is an event

  Scenario: Start event
    Given I edit the event
    And the event "never happened"
    When I click on "Start"
    Then I see the event "is happening now"

  Scenario: Stop events
    Given the event was started
    When I wait for 20 years
    And I edit the event
    And I click on "Stop"
    Then a new event activation is in the database which took 20 years
    And now the event "has happened"
