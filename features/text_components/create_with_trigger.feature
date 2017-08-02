Feature: Create with trigger
  As a reporter
  I want to add a new trigger in the same form of a new text component
  To improve the user experience

  Background:
    Given I am the journalist

  @javascript
  Scenario:
    Given I visit the new text component page
    When I click on "Create with new trigger" to see also the form fields for triggers
    And I fill in these form fields in section "Trigger":
      | Name | Trigger Hippie |
    And I fill in these form fields in section "Sensorstory-Text":
      | Heading   | Love, love, I'm a trigger hippie, yeah       |
      | Main part | Love, love, love we're trigger hippies, yeah |
    And I click on "Create Text component"
    Then there is 1 trigger and 1 text component more in the database
