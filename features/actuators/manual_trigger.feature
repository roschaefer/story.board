@136
Feature: Manual trigger
  As a service team member
  I want to trigger an actuator manually
  To check if it works correctly

  Background:
    Given there is a sensor live report

  Scenario: Click on button to trigger the actuator
    Given my reporter box has the id "0123456789abcdef"
    Given there is an actuator with id "1" that controls a light in my reporter box
    When I visit the page of this actuator
    And I click on "Activate"
    Then a request will be sent to this url:
    """
    https://api.particle.io/v1/devices/0123456789abcdef/activate
    """
    And the request payload contains this data:
    """
    args=1,1
    """
