Feature: Generate Fake Sample Data
  As a journalist
  I want generate fake sensor data
  In order to have some input for my automated report

  Background:
    Given there is a sensor live report
    And I have a sensor for the current report called "Temperature47"
    And I am the journalist

  @javascript
  Scenario: Generate Fake Sample Data
    When I visit the landing page
    And I click on "Sensors" in my dashboard
    And I click on "Temperature47" to see all the sensor readings
    And I click on "Generate Fake Sample Data"
    And I choose 10 random sensor readings with a value from 3°C to 20°C
    And I click on "Generate!"
    Then I should see some generated entries in the sensor readings table
    And this sensor should have 10 new sensor readings as fake data

  Scenario: Distinguish Fake from Real Data
    Given I have fake and real sensor readings for sensor "Temperature47"
    When I see the page of this sensor
    Then fake and real data are distinguishable

