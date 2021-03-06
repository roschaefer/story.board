@430
Feature: Generate sensorstory as JSON for frontend
  As a frontend designer
  I want the live sensorstory be generated as json (following the example of chatfuel channel)
  In order to easily integrate the sensorstory in my frontend.

  Background:
    Given we have these diary entries in our database:
      | Id | Moment           | release | Report id |
      | 1  | 2017-06-21 14:00 | final      | 4711      |
    And for that diary entry we have some text components and question answers
    And I send and accept JSON

  Scenario: Generate sensorstory on the fly and send as json
    When I send a GET request to "/reports/4711/diary_entries/1"
    Then the JSON response should be (no matter in what order):
    """
    {
      "id": 1,
      "moment": "2017-06-21T14:00:00.000+02:00",
      "release": "final",
      "text_components": [
        {
          "id": 1,
          "heading": "MyString",
          "introduction": "MyText",
          "main_part": "MyText",
          "closing": "MyText",
          "from_day": null,
          "to_day": null,
          "image_url": "/images/original/missing.png",
          "image_url_big": "/images/big/missing.png",
          "image_url_small": "/images/small/missing.png",
          "image_alt": null,
          "question_answers": [
            {
              "id": 1,
              "question": "MyText",
              "answer": "MyText",
              "text_component_id": 1
            },
            {
              "id": 2,
              "question": "MyText",
              "answer": "MyText",
              "text_component_id": 1
            }
          ],
          "url": "http://example.org/reports/4711/text_components/1.json"
        },
        {
          "id": 2,
          "heading": "MyString",
          "introduction": "MyText",
          "main_part": "MyText",
          "closing": "MyText",
          "from_day": null,
          "to_day": null,
          "image_url": "/images/original/missing.png",
          "image_url_big": "/images/big/missing.png",
          "image_url_small": "/images/small/missing.png",
          "image_alt": null,
          "question_answers": [

          ],
          "url": "http://example.org/reports/4711/text_components/2.json"
        }
      ],
      "url": "http://example.org/reports/4711/diary_entries/1.json"
    }
    """
