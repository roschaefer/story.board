Feature: Start and stop events
  As a reporter
  I want to manually start and stop events
  In order to define the range when the event happend

  Examples for our experiment in the domain of dairy cows are:
  * A calf was born
  * The doctor arrived
  * The cow died

  Therefore events
  * must be controlled manually
  * have discrete instead of continuous values

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

  Scenario: See when exactly the event was active in the past
    Given the event was active three times in the past
    When I edit the event
    Then I can see the history of the event, it looks like this:
      | Id | Started at               | Ended at                 |
      | 23  | 2017-08-04 16:19:13 UTC | 2017-08-04 16:19:15 UTC |
      | 24  | 2017-08-04 16:19:16 UTC | 2017-08-04 16:19:17 UTC |
      | 25  | 2017-08-04 16:19:18 UTC | 2017-08-04 16:19:19 UTC |


