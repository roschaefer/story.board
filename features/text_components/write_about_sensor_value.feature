@23
Feature: Write about the actual sensor value
  As a journalist
  I want to include the actual value of a sensor in a text component
  So I can tell the reader that a particular value of e.g. 970 hPa is quite low

  Background:
    Given there is a sensor live report

  Scenario: Include markup in text component
    Given I have these sensors and sensor types in my database
      | SensorID | Sensor    | Property    | Unit |
      | 1        | Temp123   | Temperature | °C   |
      | 2        | Bright456 | Light       | Lux  |
    And for my sensors I have these text components prepared:
      | Sensor    | From  | To    | Text Component                              |
      | Temp123   | 30°C  | 40°C  | Wow, it's incredible { value(1) }!          |
      | Bright456 | 70000 | 90000 | Take your sunglasses: { value(2) } outside! |
    And the latest sensor data looks like this:
      | Sensor    | Calibrated Value |
      | Temp123   | 32°C             |
      | Bright456 | 85000 Lux        |
    When I visit the landing page
    Then I should see:
    """
    Wow, it's incredible 32.0°C! Take your sunglasses: 85000.0Lux outside!
    """
