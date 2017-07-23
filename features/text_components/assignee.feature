@321
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
    And we have these users in our database
      | Name     |
      | Jane Doe |

  @javascript
  Scenario: Assign user
    Given I am logged in
    When I edit an existing text component
    And I assign the text component to "Jane Doe"
    And I click on "Update Text component"
    Then I can see that Jane was assigned to the text component


  @javascript
  Scenario: Get to text components assigned to me
    Given I am logged in
    When I click on the dropdown menu with my user account on the top right
    And I click on "My Text Components"
    Then I am on the text components page with only those assigned to me
    And I see only the text component "Man arrested for everything"

  @javascript
  Scenario: Filter by assignee
    Given I am logged in
    And I am on the text components page
    When I filter by assignee "John Doe"
    Then I see only the text component "Homicide victims rarely talk to police"
