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
    And I add a sensor reading for "2017 November 11 11:11" with a calibrated value of 25°C and an uncalibrated value of 26°C
    And I click on "Add"
    When I visit the sensors page
    And I click on "Temperature48" to see all the sensor readings
    Then I should see some generated entries in the sensor readings final table
    And this sensor should have 1 new sensor reading

  @javascript
  Scenario: Delete single sensor reading manually
    Given we have these sensor readings for sensor "Temperature50" in our database:
      | Id    | Created at       | Calibrated value | Uncalibrated value | Release |
      | 24593 | 2017-07-18 15:09 +02:00| 39.701           | 39.701             | final   |
      | 24581 | 2017-07-18 14:39 +02:00| 39.369           | 39.369             | final   |
    When I visit the sensors page
    And I click on "Temperature50" to see all the sensor readings
    And I see only 2 sensor readings
    And I click on "Add Sensor Reading manually"
    And I delete the sensor reading with the id "24593"
    When I visit the sensors page
    And I click on "Temperature50" to see all the sensor readings
    Then I see only 1 sensor readings
