@242
Feature: Add a new question/answer
  As a reporter
  I want to add arbitrary many question/answer text fields to the main part of a component
  In order to provide the data for the *Read more* button in Chatfuel

  Background:
    Given there is a sensor live report
    And we have a text component called "Monty Python and the holy grail":
    """
    King Arthur:
    Now, we are about to attempt to cross...the Bridge of Death!  The
    gate-keeper of the Bridge will ask any who attempt to cross three
    questions
    ...
    Ask me your questions, Bridgekeeper. I am not afraid.
    """

  Scenario: Add two questions/answer pairs to a text component
    Given this text component has these questions and answers already:
      | Question              | Answer                      |
      | What...is your name?  | King Arthur of the Britons! |
      | What...is your quest? | I seek the Holy Grail!      |
    When I edit this text component
    And I click on "Add a question and an answer"
    And I enter the question:
    """
    Bridgekeeper: What...is the airspeed velocity of an unladen swallow?
    """
    And I enter the answer:
    """
    Arthur: What do you mean, an African or a European swallow?
    ...
    Bridgekeeper: (confused) Well...I don't know...AAAAARRRRRRRRRRRRRRRGGGGGHHHH!!!
    """
    And I click on "Update"
    Then a new question/answer was added to the database





