@317
Feature: Character-Limit for Question Input field
  As a reporter
  I want the Question for Chatbot field limited to 20 characters (and renamed Question-Button)
  in order to fulfill the facebook-messenger limitation for buttons.

  Background:
    Given that someone is querying to the chatbot

  Scenario:
    Given I am writing a query to the chatbox
    And I enter a message that is over 20 letters long
    And I click on submit
    Then I should see an error message
