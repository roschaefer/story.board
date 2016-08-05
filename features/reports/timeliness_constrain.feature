@76
Feature: Add timeliness constraint
  As a journalist
  I want to define that a text component will be triggered only for a recent sensor reading
  Because e.g. a loud noise from five days ago is not relevant anymore

  Background:
    Given there is a sensor live report
    And I am the journalist
    Given I have these sensors and sensor types in my database
      | Sensor | Property | Unit |
      | Noise1 | Sound    | dB   |
    Given for my sensors I have these text components prepared:
      | Sensor | From   | To     | Timeliness | Text Component           |
      | Noise1 | 100 dB | 200 dB | 1          | Holy sh** what was that? |
      | Noise1 | 50 dB  | 200 dB |            | It is quite loud         |

  Scenario: Read about a very recent event
    Given the latested sensor data looks like this:
      | Sensor | Calibrated Value | Created at   |
      | Noise1 | 121db            | 1 minute ago |
    When I visit the landing page
    Then I can read this text:
    """
    Holy sh** what was that?
    [...]
    It is quite loud
    """

  Scenario: Text components without timeliness constraints win
    Given the latested sensor data looks like this:
      | Sensor | Calibrated Value | Created at   |
      | Noise1 | 121db            | 2 hours ago  |
    When I visit the landing page
    Then I can read this text:
    """
    It is quite loud
    """
    But I should NOT see:
    """
    Holy sh** what was that?
    """

