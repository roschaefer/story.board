@136
Feature: Manual trigger
  As a service team member
  I want to trigger an actuator manually
  To check if it works correctly

  Background:
    Given there is a sensor live report

  Scenario: Click on button to trigger the actuator
    Given my reporter box has the id "1e0033001747343339383037"
    Given there is an actuator with id "1" that controls a light in my reporter box
    When I visit the page of this actuator
    And I click the 'Activate' button to trigger the actuator
    Then a request will be sent to this url:
    """
    https://api.particle.io/v1/devices/1e0033001747343339383037/activate
    """
    And the request payload contains this data:
    """
    args=1,1
    """
    And the command was successfully executed
