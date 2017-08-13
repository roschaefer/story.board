Feature: Identify Sensors by I2C Address
  As a member of the service team,
  I want my sensor readings to include an I2C Address
  So the story.board can distinguish two similar sensors based on this address

  Background:
    Given I send and accept JSON

  Scenario Outline: Receive sensor reading with an I2C address
    Given I have a sensor with a I2C address <address>
    When I send a POST request to "/reports/1/sensors/1/sensor_readings" with the following:
    """
    {
    "calibrated_value": 47,
    "uncalibrated_value": 11,
    "sensor": {
        "address": <address>
      }
    }
    """
    And notice that we OVERRIDE the given sensor id 1 here
    Then the response status should be "201"
    And now the sensor has a new sensor reading in the database

    Examples:
      | address | note                    |
      | "4711"  | either a decimal number |
      | "0xAF"  | or a hex number         |
      | "0xbC"  | hex is case-insensitive |
