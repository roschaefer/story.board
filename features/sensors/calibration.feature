@164
Feature: Button for calibration
  As member of service team
  I want to have a button to start calibration of reporter.box
  in order to gather highest and lowest sensor values

  Background:
    Given there is a sensor live report
    And I am a service team member

  Scenario: Start calibration phase and gather extreme values
    Given I have a sensor for "Temperature"
    When I visit its sensor page
    And I click on "Start calibration"
    And all subsequent sensor readings will be intercepted for a while
    When I visit the sensor page again
    And I click on "Stop calibration"
    Then the highest and lowest values will be stored as extreme values for the sensor
    And I can see the calibration values on the sensor page

  Scenario: A second calibration will clear min and max values
    Given I have a sensor for "Temperature"
    And this sensor was calibrated already
    When I visit its sensor page
    And I click on "Start calibration"
    Then the calibration values of this sensor will be cleared
