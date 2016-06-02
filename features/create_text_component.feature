Feature: Create Text Component
  As a journalist
  I want to create new text components for my live report
  To control the input for the text generator


  Background:
    Given there is a sensor live report

  Scenario:
    Given I am the journalist
    When I visit the landing page
    And I click on "Text Components" in my dashboard
    And I click on "Add new text component" to create a new text component
    And I type in some text for Heading, Introduction, Main part, Closing
    And I confirm the dialog
    Then I have a new text component for my live report in the database

