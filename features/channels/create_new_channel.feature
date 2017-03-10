@246
Feature: Create new channels
  As member of the service team
  I want to create new channels for the report
  In order to group text components in a channel and in order to define an API endpoint

  Background:
    Given I am a member of the service team
    And I take care of a report called "Rainbows and Unicorns"

  Scenario: Provide an endpoint
    When I edit the report
    And enter a new channel called "Magic" and click on "Add"
    Then there is a new channel in the database
    And I can reach an endpoint for my channel at '/channels/:id'


