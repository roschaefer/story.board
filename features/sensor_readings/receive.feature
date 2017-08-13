Feature: Receive Sensor Readings
  As a journalist
  I want my story.board to receive sensor readings from the reporter.box
  In order to collect and store the raw sensor data

  Background:
    Given I send and accept JSON

  Scenario: Receive sensor reading data
    Given I have a sensor with id 1
    When I send a POST request to "/reports/1/sensors/1/sensor_readings" with the following:
    """
    {
      "calibrated_value": 47,
      "uncalibrated_value": 11
    }
    """
    Then the response status should be "201"
    And a new sensor reading was created

  Scenario: Assign sensor reading to sensor based on the name
    Given I have a sensor called "DS18B20"
    When I send a POST request to "/reports/1/sensors/4711/sensor_readings" with the following:
    """
    {
      "calibrated_value": 47,
      "uncalibrated_value": 11,
      "sensor": {
        "name": "DS18B20"
      }
    }
    """
    And notice that we OVERRIDE the given sensor id 4711 here
    Then the response status should be "201"
    And a new sensor reading was created

  Scenario: Reject sensor reading with a non-existent name
    Given I have a sensor called "DS18B20"
    When I send a POST request to "/reports/1/sensors/4711/sensor_readings" with the following:
    """
    {
      "calibrated_value": 47,
      "uncalibrated_value": 11,
      "sensor": {
        "name": "DOESN'T EXIST"
      }
    }
    """
    And notice that we OVERRIDE the given sensor id 4711 here
    Then the response status should be "422"
    And no sensor reading was created
