Feature: Add sensor reading manually
  As a journalist
  I want add sensor readings manually
  In order to have input for a sensor when the input can't be generated automatically

  Background:
    Given there is a sensor live report
    And I have a sensor for the current report called "Temperature48"
    And I am the journalist

  @javascript
  Scenario: Add single sensor reading manually
    When I visit the sensors page
    And I click on "Temperature48" to see all the sensor readings
    And I click on "Add Sensor Reading manually"
    And I add a sensor reading for "2011-01-11 11:11:11" with a calibrated value of 25°C and an uncalibrated value of 26°C
    And I click on "Add"
    When I visit the sensors page
    And I click on "Temperature48" to see all the sensor readings
    Then this sensor should have 1 new sensor reading
