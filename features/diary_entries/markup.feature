@453
Feature: Render markup for frontend
  As a frontend designer
  I want markup in diary entries to be replaced with e.g. values of sensor readings
  To incorporate sensor reading values in the report

  Background:
    Given we have these diary entries in our database:
      | Id | Moment           | release |
      | 1  | 2017-06-21 14:00 | final   |
    And a humidity sensor with some sensor readings
    And for this diary entry we have an active text component:
    """
    The humidity today is { value(1) }!
    """
    And I send and accept JSON

  Scenario: Render sensor reading value
    When I send a GET request to "/reports/1/diary_entries/1"
    Then the JSON response should be:
    """
    {
      "id": 1,
      "moment": "2017-06-21T14:00:00.000Z",
      "release": "final",
      "text_components": [
        
        {
          "id": 1,
          "heading": "MyString",
          "introduction": "MyText",
          "main_part": "The humidity today is 50.0 %!",
          "closing": "MyText",
          "from_day": null,
          "to_day": null,
          "question_answers": [ ],
          "url": "http://example.org/reports/1/text_components/1.json"
        }
      ],
      "url": "http://example.org/reports/1/diary_entries/1.json"
    }
    """
