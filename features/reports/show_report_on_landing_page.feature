Feature: Show Report on Landing Page
  As a reader
  I want to read the latest generated report on the landing page
  Because I'm interested to see what happened in the experiment recently

  Background:
    Given there is a sensor live report

  Scenario: Visit Landing Page
    When I visit the landing page
    Then I should see:
    """
    This is the live report of your experiment
    """

  Scenario: Read about the Latest Data
    Given I have a sensor for the current report called "Temperature123"
    And this sensor just measured a temperature of 30°C
    And I prepared a text component with this introduction:
    """
    Oh my god it's so hot right now! I'm dying.
    """
    And and this component should trigger for a value between 25°C and 45°C
    When I visit the landing page
    Then I should see:
    """
    Oh my god it's so hot right now! I'm dying.
    """
