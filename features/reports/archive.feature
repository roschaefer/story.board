@20 @wip
Feature: Archive Reports
  As a reader
  I want to scroll down the previously generate live reports
  In order to read about what has happened in the experiment before

  Background:
    Given there is a sensor live report
    And I have these sensors and sensor types in my database
      | Sensor | Property   | Unit |
      | Wind   | Wind force | km/h |
    And for my sensors I have these text components prepared:
      | Sensor | From | To | Text Component                     |
      | Wind   | 0    | 40 | Not very windy today.              |
      | Wind   | 40   | 80 | Watch out, it's quite windy today. |
    And the latest sensor data looks like this:
      | Sensor | Calibrated Value |
      | Wind   | 10km/h           |

  Scenario: See archived reports on the landing page
    Given I visit the landing page
    And I see the current live report:
    """
    Not very windy today.
    """
    When I wait for five hours
    And the latest sensor data looks like this:
      | Sensor | Calibrated Value |
      | Wind   | 50km/h           |
    Then I see the new live report:
    """
    Watch out, it's quite windy today
    """
    And I can see the archived report:
    """
    Not very windy today.
    """
