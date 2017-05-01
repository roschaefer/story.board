@248
Feature: Read more question
  As a reader using the Facebook Messenger
  I want to be asked, if i want to continue reading
  In order not to be overwhelmed by the amount of text
  Background:
    Given a topic "milk_quality"
    And we have an active text component for that topic with these question/answers:
      | Question                              | Answer        |
      | What do you call a sleeping cow?      | A bull-dozer. |
      | What has one horn and gives milk?     | A milk truck. |

  Scenario: GET request a channel and receive a clickable question
    When I send a GET request to "/chatfuel/milk_quality"
    Then the response status should be "200"
    And the JSON response should be:
    """
    {
      "messages": [
        {
          "attachment": {
            "payload": {
              "template_type": "button",
              "text": "The main part of the text component will be displayed here.",
              "buttons": [
                {
                  "url": "http://localhost:3000/chatfuel/text_components/1/answer_to_question/1",
                  "type":"json_plugin_url",
                  "title":"What do you call a sleeping cow?"
                }
              ]
            },
            "type": "template"
          }
        }
      ]
    }
    """

  Scenario: Click the question and receive the answer along with the next question
    When I click the question from the first scenario
    Then the response status should be "200"
    And the JSON response should be:
    """
    {
      "messages": [
        {
          "attachment": {
            "payload":{
              "template_type": "button",
              "text": "A bull-dozer.",
              "buttons": [
                {
                  "url": "http://localhost:3000/chatfuel/text_components/1/answer_to_question/2",
                  "type":"json_plugin_url",
                  "title": "What has one horn and gives milk?"
                }
              ]
            },
            "type": "template"
          }
        }
      ]
    }
    """
  Scenario: The last answer in the queue will only send a message
    When I click the question from the second scenario
    Then the response status should be "200"
    And the JSON response should be:
    """
    {
     "messages": [
       {"text": "A milk truck."}
     ]
    }
    """
