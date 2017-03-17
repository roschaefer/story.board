@259
Feature: Provide endpoint for each channel
  As a developer
  I want to have an endpoint for each channel which returns a message with the relevant text
  In order to get the input for e.g. a chatbot

  Background:
    Given there is a sensor live report
    And our sensor live report has a channel "chatbot"
    And a topic "milk_quality"
    And we created a text component for it that is active right now

  Scenario: GET request a channel
    When I send a GET request to "/chatbot/milk_quality"
    Then the response status should be "200"
    And the JSON response should be:
    """
    {
    "messages": [
      {"text": "Got milk?"}
    ]
    }
    """
