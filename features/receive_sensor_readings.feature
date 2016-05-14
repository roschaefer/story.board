Feature: Receive Sensor Readings
  As a journalist
  I want my story.board to receive sensor readings from the reporter.box
  In order to collect and store the raw sensor data

  Scenario: Receive Sensor Readings as JSON data
    Given I have a sensor called "DS18B20"
    When I send a POST request to "/api/sensor_readings" with the following:
    """
    {
      “Measurement”: {
        “Name”: “DS18B20”,
        “Addr”: “4711”,
        “Type : “TMP”,
        “Unit”: “C”,
        “Value”: “25”
        “CalValue”: “”
        “Timestamp”: "2012-04-23T18:25:43.511Z”
      }
    }
    """
    Then the response status should be "201"
    And a new sensor reading was created
