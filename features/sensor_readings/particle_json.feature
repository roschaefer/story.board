Feature: Interface to Particle API

  Background:
    Given I send and accept JSON

  Scenario: Receive a Particle JSON with an address
    Given I have a sensor with a I2C address "123"
    When I send a POST request to "/reports/1/sensors/1/sensor_readings" with the following:
    """
    {
    "event": "measurement",
    "data": "{ \"calibrated_value\": 47, \"uncalibrated_value\": 11, \"sensor\": { \"address\": 123 } }",
    "published_at": "2016-06-05T13:41:18.705Z",
    "coreid": "1e0033001747343339383037"
    }
    """
    And notice that we OVERRIDE the given sensor id 1 here
    And by the way, the "data" attribute above is a string
    Then the response status should be "201"
    And now the sensor has the following readings in the database:
      | Calibrated value | Uncalibrated value |
      | 47               | 11                 |

  Scenario: Receive a Particle JSON with values
    Given I have a sensor with id 4711
    When I send a POST request to "/reports/1/sensors/4711/sensor_readings" with the following:
    """
    {
    "event": "measurement",
    "data": "{ \"calibrated_value\": 8, \"uncalibrated_value\": 15 }",
    "published_at": "2016-06-05T13:41:18.705Z",
    "coreid": "1e0033001747343339383037"
    }
    """
    Then the response status should be "201"
    And now the sensor has the following readings in the database:
      | Calibrated value | Uncalibrated value |
      | 8                | 15                 |

  Scenario: Invalid JSON data string
    Given I have a sensor with id 4711
    When I send a POST request to "/reports/1/sensors/4711/sensor_readings" with the following:
    """
    {
    "event": "measurement",
    "data": "{ \"calibrated_value\": 8",
    "published_at": "2016-06-05T13:41:18.705Z",
    "coreid": "1e0033001747343339383037"
    }
    """
    Then the response status should be "400"
