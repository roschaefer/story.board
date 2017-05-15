@317
Feature: Character-Limit for Question Input field
  As a reporter
  I want the Question for Chatbot field limited to 20 characters (and renamed Question-Button)
  in order to fullfill the facebook-messenger limitation for buttons.

  Background:
    Given that someone is querying to the chatbot

  Scenario:
    Given I am writing a query to the chatbox
    I enter a message that is maximum 20 letters long
    I click on submit
    Then the question should be posted to the chatbox
