@108
Feature: Insert break and add sub-headings
  As a reader
  I would like to have sensor-live-reports structured in paragraphs
  Because small chunks of texts are easier to read

  Details:
  * Every 500+ characters an automated break after last trigger
  * Heading of next trigger becomes subheading

  Background:
    Given there is a sensor live report
    And I am the journalist

  Scenario: In case of a draw, chose a heading randomly
    Given I have these active triggers:
      | Priority | Heading                                   |
      | high     | Using headings in your report             |
      | low      | Wow, this is really boring                |
    But there is a medium prioritized, active component with a really long text
    When I visit the landing page
    Then I can see the main heading:
    """
    Using headings in your report
    """
    And I can see a subheading:
    """
    Wow, this is really boring
    """


