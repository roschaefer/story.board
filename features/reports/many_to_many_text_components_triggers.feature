@169
Feature: Many-to-many between text components and triggers
  As a journalist
  I want to share triggers among many text components, and some text components have many triggers
  In order to write a text that has a relevance only if two situations happen at once

  Background:
    Given there is a sensor live report
    And I am the journalist

  Scenario: Two text components show up in the report in the same situation
    Given I have these active triggers:
      | Trigger        |
      | Some situation |
    And these are the connections between text components and triggers:
      | Trigger        | Text component |
      | Some situation | It's happening |
      | Some situation | Right now!     |
    When I visit the landing page
    Then I can see these pieces of text in the report:
      | Part           |
      | It's happening |
      | Right now!     |

