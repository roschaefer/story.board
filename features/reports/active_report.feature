@348
Feature: Filter by active report
  As a reporter
  I always want to have a selected report and filter text.components, triggers and sensors by this selected report
  In order to keep an overview

  Background:
    Given the current report is "Massive Livestock Farm"

  Scenario: There is always a selected report
    When I visit the landing page
    Then I can see the current report "Massive Livestock Farm" in the menu bar

  @javascript
  Scenario Outline: Filter text components, sensors and triggers by active report
    Given we have these <thing>s:
      | <column_name> | Report                 |
      | <record_1>    | Massive Livestock Farm |
      | <record_2>    | Organic Farm           |
    And I am the journalist
    When I visit the present page of the current report
    And I first navigate to the <thing> page
    Then I see only the <thing> "<record_1>"
    But when I choose "Organic Farm" to be the active report
    And I navigate to the <thing> page
    Then I see only the <thing> "<record_2>"

    Examples:
      | thing          | column_name    | record_1           | record_2     |
      | text component | Text component | Big MOOOOH         | Happy cattle |
      | trigger        | Trigger        | High temperature   | Low PH scale |
      | sensor         | Sensor         | Temperature sensor | PH sensor    |
