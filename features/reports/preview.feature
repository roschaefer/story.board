Feature: Preview
  As a journalist
  I want to have an internal preview of the generated live-sensor-report based on sample data
  So I can anticipate how the next report will look like

  Background:
    Given there is a sensor live report
    And I am the journalist

  Scenario: Show a Preview of the Live-Report based on Fake Data
    Given for my current report I have these triggers prepared:
      | Sensor    | From | To   | Trigger |
      | Temp123   | 30°C | 40°C | Warm    |
      | Bright456 | 7    | 10   | Bright  |
    And these are the connections between text components and triggers:
      | Trigger | Text component                                  |
      | Warm    | The consequences of global warming fall upon us |
      | Bright  | Oh gosh, my eyes hurt!                          |
    And there is some generated test data:
      | Sensor    | Calibrated Value |
      | Temp123   | 37°C             |
      | Bright456 | 9                |
    When I visit the landing page
    And I click on the preview of the current report
    Then I can read this text:
    """
    The consequences of global warming fall upon us
    [...]
    Oh gosh, my eyes hurt!
    """
