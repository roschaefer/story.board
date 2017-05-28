@20
Feature: Archive Reports
  As a reader
  I want to scroll down the previously generate live reports
  In order to read about what has happened in the experiment before

  Background:
    Given there is a sensor live report
    And I have these sensors and sensor types in my database
      | Sensor | Property   | Unit |
      | Wind   | Wind force | km/h |
    And for my sensors I have these triggers prepared:
      | Sensor | From | To | Trigger     |
      | Wind   | 0    | 40 | Not windy   |
      | Wind   | 40   | 80 | Quite windy |
    And these are the connections between text components and triggers:
      | Trigger     | Text component                     |
      | Not windy   | Not very windy today.              |
      | Quite windy | Watch out, it's quite windy today. |
    And the latest sensor data looks like this:
      | Sensor | Calibrated Value |
      | Wind   | 10km/h           |

  @javascript
  Scenario: See archived reports on the landing page
    Given I visit the landing page
    And I see the current live report:
    """
    Not very windy today.
    """
    When the application archives the current report
    And the latest sensor data looks like this:
      | Sensor | Calibrated Value |
      | Wind   | 50km/h           |
    And I reload the page
    Then I see the new live report:
    """
    Watch out, it's quite windy today
    """
    And I can see the archived report:
    """
    Not very windy today.
    """
