@187
Feature: Time of the day
  As a journalist
  I want to set a specific time interval (time of day) for every text component.
  To write about regular events that happen e.g. every mornging

  Background:
    Given there is a sensor live report
    And some triggers are active at certain hours:
      | Trigger      | From  | To    |
      | Good morning | 06:00 | 11:00 |
      | Sleep well   | 21:00 | 06:00 |
    And these are the connections between text components and triggers:
      | Trigger      | Text component              |
      | Good morning | Hello again                 |
      | Sleep well   | Now it's time to go to bed. |

  Scenario: See the good morning text component
    When I visit "/reports/present/1/?at=2017-08-19T10:00+02:00"
    Then I see the current live report:
    """
    Hello again
    """
    But I should NOT see:
    """
    Now it's time to go to bed.
    """

  Scenario: See the evening's text component
    When I visit "/reports/present/1/?at=2017-08-19T22:00+02:00"
    Then I see the current live report:
    """
    Now it's time to go to bed.
    """
    But I should NOT see:
    """
    Hello again
    """
