@243
Feature: Choose one or many channels
  As a reporter
  I want to choose one or more channels for my text component
  In order to associate the text component with a channel

  Background:
    Given there is a sensor live report
    And there is a channel called "simple"
    And I am a journalists who writes about the theory of relativity
    But the theory of relativity is too difficult for everybody to understand

  @javascript
  Scenario: Replace default channel with another one
    Given I created several text components already, explaining the topic on different levels
    And this is for the eggheads out there:
    """
    States of accelerated motion, being at rest in a gravitational field.
    Curved spacetime and gravitational wave blah blah
    """
    And that is more easy to savvy:
    """
    Relativity. Boom. Awesome.
    """
    When I edit the easier text component
    And unselect "sensorstory" as a channel
    And choose "simple" as a channel
    And I update the text component
    Then the easier text will go into the channel "simple"
    And the easier text will not appear in main story
