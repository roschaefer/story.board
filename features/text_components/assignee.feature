Feature: Assignee
  As a editor in lead
  I want to set an assignee for every text.component
  To manage responsibilities among the team

  Background:
    Given my user name is "Myself"
    And we have these text components:
      | Text component                         | Assignee |
      | Cow urine makes for juicy lemons       |          |
      | Man arrested for everything            | Myself   |
      | Homicide victims rarely talk to police | John Doe |

  @javascript
  Scenario: Assign user
    Given we have these users in our database
      | Name     |
      | Jane Doe |
    When I edit an existing text component
    And I choose "Jane Doe" from the dropdown menu "Assignee"
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
    When I filter by assignee "John Doe"
    Then I see only the text component "Homicide victims rarely talk to police"
