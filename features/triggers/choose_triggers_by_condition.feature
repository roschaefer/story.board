Feature: Choose Trigger by Condition
  As a journalist
  I want triggers to appear in the live report only if certain conditions hold
  So the live report delivers some meaning about the recently received sensor readings

  Background:
    Given there is a sensor live report

  Scenario: Check if sensor reading is within range
    Given for my current report I have these triggers prepared:
      | Sensor    | From | To   | Trigger       |
      | Temp123   | 20°C | 25°C | It's nice today.     |
      | Bright456 | 0    | 3    | I can't see a thing! |
    And the latest sensor data looks like this:
      | Sensor    | Calibrated Value |
      | Temp123   | 15°C             |
      | Bright456 | 2                |
    When I visit the landing page
    Then I should see:
    """
    I can't see a thing!
    """
    But I should NOT see:
    """
    It's nice today.
    """

