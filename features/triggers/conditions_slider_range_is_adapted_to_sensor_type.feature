Feature: Update condition slider range 
  As editor when I edit triggers
  I want sensor conditions to update the slider range depending on the sensor type
  In order to reduce errors and improve user experience

  Background:
    Given I am the journalist
    And I have these sensors and sensor types in my database
      | SensorID | Sensor | Sensor type | Min | Max | Unit | FractionDigits |
      | 1        | Temp1  | Temperature | -30 | 80  | °C   | 1              |
      | 2        | PH1    | pH Value    | 0   | 14  | pH   | 2              |

  @javascript
  Scenario:
    When I create a new trigger
    And I add a condition
    And I choose the sensor "Temp1" to trigger this trigger
    Then slider has a range from "-30.0 °C" to "80.0 °C" with a step size of "0.1"
    But when I choose the sensor "PH1" to trigger this trigger
    Then slider has a range from "0.0 pH" to "14.0 pH" with a step size of "0.01"

  @javascript
  Scenario: Slider is initialized with a given sensor of an existing trigger
    Given for my current report I have these triggers prepared:
      | Sensor | From  | To  | Trigger  |
      | Temp1  | -20°C | 0°C | F** cold |
    When I edit the trigger "F** cold"
    Then slider has a range from "-30.0 °C" to "80.0 °C" with a step size of "0.1"
    And the two bars of the slider are at position "-20,0" and "0"
