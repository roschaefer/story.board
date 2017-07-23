Feature: Generate debug Sample Data
  As a journalist
  I want generate debug sensor data
  In order to have some input for my automated report

  Background:
    Given there is a sensor live report
    And I have a sensor for the current report called "Temperature47"
    And I am the journalist

  @javascript
  Scenario: Generate debug Sample Data
    When I visit the sensors page
    And I click on "Temperature47" to see all the sensor readings
    And I click on "Generate debug Sample Data"
    And I choose 10 random sensor readings with a value from 3°C to 20°C
    And I click on "Generate!"
    Then I should see some generated entries in the sensor readings table
    And this sensor should have 10 new sensor readings as debug data

  Scenario: Distinguish debug from final Data
    Given I have debug and final sensor readings for sensor "Temperature47"
    When I see the page of this sensor
    Then debug and final data are distinguishable
