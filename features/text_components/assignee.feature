Feature: Assignee
  As a editor in lead
  I want to set an assignee for every text.component
  To manage responsibilities among the team

  @javascript
  Scenario:
    Given we have these users in our database
      | Email                |
      | john.doe@example.org |
      | jane.doe@example.org |
    When I edit an existing text component
    And I choose "jane.doe@example.org" from the dropdown menu "Assignee"
    And I click on "Update Text component"
    Then I can see that Jane was assigned to the text component
