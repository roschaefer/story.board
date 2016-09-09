@136
Feature: Manual trigger
  As a service team member
  I want to trigger an actor manually
  To check if it works correctly

  Background:
    Given there is a sensor live report

  Scenario: Click on button to trigger the actor
    Given my reporter box has the id "0123456789abcdef"
    Given there is an actor that controls a light in my reporter box
    When I visit the page of this actor
    And I click on "Activate"
    Then a request will be sent to this url:
    """
    https://api.particle.io/v1/devices/0123456789abcdef/light
    """
    And the request payload contains this data:
    """
    args=on
    """
