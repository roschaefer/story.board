Feature: Distinguish between reports

  Scenario Outline:
    Given we have these text components for the chatbot:
      | Text component                  | report_id | Topic        |
      | It's about sensory data         | 1         | milk_quality |
      | Robots are conquering the world | 2         | milk_quality |
    When I send a GET request to "/reports/<report_id>/chatfuel/milk_quality"
    Then the response status should be "200"
    And the JSON response should be:
    """
    {
    "messages": [
      {"text": "<expected_message>"}
    ]
    }
    """

    Examples:
      | report_id | expected_message                |
      | 1         | It's about sensory data         |
      | 2         | Robots are conquering the world |
