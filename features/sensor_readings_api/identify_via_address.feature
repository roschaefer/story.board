Feature: Identify Sensors by I2C Address
  As a member of the service team,
  I want my sensor readings to include an I2C Address
  So the story.board can distinguish two similar sensors based on this address

  Background:
    Given I send and accept JSON

  Scenario: Receive sensor reading with I2C address as HEX number
    Given I have a sensor with a I2C address "0xAF"
    When I send a POST request to "/sensor_readings" with the following:
    """
    {
    "address": "0xAF",
    "calibrated_value": 47,
    "uncalibrated_value": 11
    }
    """
    Then the response status should be "201"
    And now the sensor has a new sensor reading in the database
