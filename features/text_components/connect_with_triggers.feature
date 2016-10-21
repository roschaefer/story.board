Feature: Connect text components with triggers
  As a journalist
  I want to connect triggers with text components on the text components page
  In order to set up the many to many relation

  Background:
    Given there is a sensor live report

  Scenario: Add two triggers to the text component
    Given I have these active triggers:
      | Trigger           |
      | Some situation    |
      | Another situation |
    And I have a text component with a heading "What's happening now?"
    When I visit the edit page of this text component
    And I add a trigger and choose "Another situation"
    And I add another trigger and choose "Some situation"
    And I click on update
    Then the text component is connected to both triggers


