Feature: Username required
  As a reporter
  I want to choose an assignee by his name, not his email address
  In order to easily identify assignees

  Scenario: Sign up requires username
    Given I am on the signup page
    And I fill in a valid email and a password
    When I click on "Sign up"
    Then I see error message telling me the user name can't be blank

  Scenario: Change my username
    Given I am user "Stinky Stacy" and I am logged in
    When I edit my account and fill in my new name "Wendy Wacko"
    Then I just need to confirm my password and click on "Update"
    And I can see, I'm called "Wendy Wacko" now

