Feature: Connect with a condition
  As a journalist
  I want to connect my triggers with certain conditions
  So I can define which trigger should occur for a certain value of a sensor

  Background:
    Given I am the journalist

  @javascript
  Scenario: Edit the Trigger and Connect with a Condition
    Given I have a temperature sensor called "Temp23"
    And I have a trigger with the name "Das Grosse Zittern"
    When I visit the edit page of this trigger
    And I add a condition
    And I choose the sensor "Temp23" to trigger this trigger
    And I define a range from "0" to "15" to cover the relevant values
    And I click on update
    Then the trigger is connected to the temperature sensor
    And the condition has relevant values from 0 to 15

