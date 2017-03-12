@243
Feature: Choose one or many channels
  As a reporter
  I want to choose one or more channels for my text component
  In order to associate the text component with a channel

  Background:
    Given there is a channel called "simple"
    Given I am a journalists who writes about the theory of relativity
    But the theory of relativity is too difficult for everybody to understand

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
    And choose "simple" as a channel and remove the default channel "sensorstory"
    Then only the difficult text will go into the main report
    And the easier text will go into the channel "simple"
