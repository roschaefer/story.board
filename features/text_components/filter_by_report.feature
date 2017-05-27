Feature: Filter by active report
  As a reporter
  I always want to have a selected report and filter text.components, triggers and sensors by this selected report
  In order to keep an overview

  Background:
    Given the current report is "Massive Livestock Farm"
    And we have these text components:
      | Text component | Report                 |
      | Big MOOOOH     | Massive Livestock Farm |
      | Happy cattle   | Organic Farm           |

  Scenario: There is always a selected report
    When I visit the landing page
    Then I can see the current report "Massive Livestock Farm" in the menu bar

  @javascript
  Scenario: Visit two different text component index pages
    Given I visit the landing page
    And I first navigate to the text component page
    And I see only the text component "Big MOOOOH"
    When I choose "Organic Farm" to be the active report
    And I navigate to the text component page
    Then I see only the text component "Happy cattle"
