Feature: Assignee
  As a editor in lead
  I want to set an assignee for every text.component
  To manage responsibilities among the team

  Background:
    Given my own account is "me@example.org"
    And we have these text components:
      | Text component                         | Assignee             |
      | Cow urine makes for juicy lemons       |                      |
      | Man arrested for everything            | me@example.org       |
      | Homicide victims rarely talk to police | john.doe@example.org |

  @javascript
  Scenario: Assign user
    Given we have these users in our database
      | Email                |
      | jane.doe@example.org |
    When I edit an existing text component
    And I choose "jane.doe@example.org" from the dropdown menu "Assignee"
    And I click on "Update Text component"
    Then I can see that Jane was assigned to the text component


  Scenario: Get to text components assigned to me
    Given I am logged in
    When I click on the dropdown menu with my user account on the top right
    And I click on "Text components assigned to me"
    Then I am on the text components page with only those assigned to me
    And I see only the text component "Man arrested for everything"

  @javascript
  Scenario: Filter by assignee
    Given I am on the text components page
    When I filter by assignee "john.doe@example.org"
    Then I see only the text component "Homicide victims rarely talk to police"
