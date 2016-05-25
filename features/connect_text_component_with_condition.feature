Feature: Connect with a condition
  Feature: Receive Sensor Readings
  As a journalist
  I want my story.board to receive sensor readings from the reporter.box


  @javascript
  Scenario: Edit the Text Component and Connect with a Condition
    Given I have a temperature sensor called "Temp23"
    And I have a text component with the heading "Das Grosse Zittern"
    When I visit the edit page of this text component
    And I add a condition
    And I choose the sensor "Temp23" to trigger this text component
    And I define a range from "0" to "15" to cover the relevant values
    And I click on update
    Then the text component is connected to the temperature sensor
    And the condition has relevant values from 0 to 15

