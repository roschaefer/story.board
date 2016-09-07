@120
Feature: Connect with events
  As a journalist
  I want to include the name and the moment of an event in a text component
  So I can write about the day when the event has happened

  Background:
    Given there is a sensor live report

  Scenario: Include markup in text component
    Given I have these events in my database
      | EventID | Event         |
      | 1       | Judgement Day |
    And have some text components prepared that will trigger on a particular event
      | Event         | Main part                                                          |
      | Judgement Day | At last! On{ date(1) } all sinners tremble! Judgement day has come. |
    And the event "Judgement Day" has happened on "2017-01-01"
    When I visit the landing page
    Then I should see:
    """
    At last! On January 1st 2017 all sinners tremble! Judgement day has come.
    """
