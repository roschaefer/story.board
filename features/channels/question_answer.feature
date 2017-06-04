@248
Feature: Read more question
  As a reader using the Facebook Messenger
  I want to be asked, if i want to continue reading
  In order not to be overwhelmed by the amount of text
  Background:
    Given a topic "milk_quality"
    And we have an active text component with the id 1 for that topic with these question/answers:
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
                  "url": "http://example.org/chatfuel/text_components/1/answer_to_question/1",
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
                  "url": "http://example.org/chatfuel/text_components/1/answer_to_question/2",
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
  Scenario: The last answer in the queue will send an answer and redirect to a block, dependant on the topic (block name: continue_[topic.name])
    When I click the question from the second scenario
    Then the response status should be "200"
    And the JSON response should be:
    """
    {
      "messages": [
        {
          "text": "A milk truck."
        }
      ],
      "redirect_to_blocks": ["continue_milk_quality"]
    }
    """
