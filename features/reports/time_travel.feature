@97
Feature: Read about any point in time
  As a reader
  I want to read reports at any point back in time
  Because I am interested in a certain moment in time

  Background:
    Given there is a sensor live report
    And I have these sensors and sensor types in my database
      | Sensor       | Property    | Unit |
      | Summer-Antenna| Temperature | °C   |
    And for my sensors I have these triggers prepared:
      | Sensor         | From | To | Trigger |
      | Summer-Antenna | 0    | 24 | Cold    |
      | Summer-Antenna | 25   | 40 | Hot     |
    And these are the connections between text components and triggers:
      | Trigger | Text component                          |
      | Cold    | When will there be a good summer again? |
      | Hot     | Now it is a really good summer.         |
    And we have this sensor data in our database:
      | Sensor         | Calibrated value | Created at |
      | Summer-Antenna | 40°C             | 2016-07-01 |
      | Summer-Antenna | 35°C             | 2016-07-08 |
      | Summer-Antenna | 30°C             | 2016-07-15 |
      | Summer-Antenna | 25°C             | 2016-07-22 |
      | Summer-Antenna | 20°C             | 2016-07-29 |
      | Summer-Antenna | 15°C             | 2016-08-05 |
      | Summer-Antenna | 10°C             | 2016-08-12 |

  Scenario: See archived reports on the landing page
    Given I visit the landing page
    And I see the current live report:
    """
    When will there be a good summer again?
    """
    When I append the following parameter to the url:
    """
    ?at=2016-07-25T11:34+01:00
    """
    Then according to the live report it is summer again!
    """
    Now it is a really good summer.
    """
    And I should NOT see:
    """
    When will there be a good summer again?
    """
