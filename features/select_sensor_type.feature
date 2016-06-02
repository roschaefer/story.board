Feature: Select Sensor Type and Sensor ID
  As journalist
  I want to configure my sensors from a pre-known set of available sensor types and sensor IDs
  So I have less trouble with configuration

  Background:
    Given there is a sensor live report

  Scenario: Create new Sensor and Select Sensor Type
    Given all "Temperature" sensors measure in "Celsius"
    When I want to create a new sensor
    And I select the sensor type "Temperature"
    And I confirm the dialog
    Then I have a new sensor in my database
