Feature: Interface to Particle API

  Background:
    Given I send and accept JSON

  Scenario: Receive a normal Particle JSON
    Given I have a sensor with a I2C address "123"
    When I send a POST request to "/sensor_readings" with the following:
    """
    {
    "event": "measurement",
    "data": "{ \"calibrated_value\": 47, \"uncalibrated_value\": 11, \"sensor\": { \"address\": 123 } }",
    "published_at": "2016-06-05T13:41:18.705Z",
    "coreid": "1e0033001747343339383037"
    }
    """
    And by the way, the "data" attribute above is a string
    Then the response status should be "201"
    And now the sensor has a new sensor reading in the database
