@317
Feature: Character-Limit for Question Input field
  As a reporter
  I want the Question for Chatbot field limited to 20 characters (and renamed Question-Button)
  in order to fulfill the facebook-messenger limitation for buttons.

  Background:
    Given I am the journalist

  @javascript
  Scenario:
    Given I am composing some question answers for a text component
    When I enter a question that is more than 20 characters long
    And I click on "Update"
    Then I see the error message in section "Chatbot Q/A":
      | Label   | Question                                                     |
      | Message | is too long for a chatfuel button (maximum is 20 characters) |
