@259 @wip
Feature: Provide endpoint for each channel
  As a developer
  I want to have an endpoint for each channel which returns a message with the relevant text
  In order to get the input for e.g. a chatbot

  Background:
    Given our sensor live report has a channel "wisdom" with the id 42
    And we created a text component for it that is active right now

  Scenario: GET request a channel
    When I send a GET request to "/reports/1/channels/42"
    Then the response status should be "200"
    And the JSON response should be:
    """
    {
    "messages": [
      {"text": "If you think there is good in everybody, you haven't met everybody."}
    ]
    }
    """

