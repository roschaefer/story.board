Feature: Connect text components with triggers
  As a journalist
  I want to connect triggers with text components on the text components page
  In order to set up the many to many relation

  Background:
    Given there is a sensor live report

  @javascript
  Scenario: Add two triggers to the text component
    Given I have these active triggers:
      | Trigger           |
      | Some situation    |
      | Another situation |
    And I have a text component with a heading "What's happening now?"
    When I edit this text component
    And I add a trigger and choose "Another situation"
    And I add another trigger and choose "Some situation"
    And I update the text component
    Then the text component is connected to both triggers


