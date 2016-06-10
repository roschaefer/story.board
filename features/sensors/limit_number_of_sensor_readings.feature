Feature: Limit number of Sensor Readings
  As a journalist
  I want to see only the latest sensor readings on the sensor page
  Because I don't want to be overwhelmed by thousands of database entries

  Scenario: Show only Latest Data
    Given I have 100 entries for a sensor in my database
    When I visit the page of that sensor
    Then I see only 50 sensor readings
    And the first row is the most recent sensor reading

