@206
Feature: Read more button
  As a reader who is sometimes more, sometimes less interested
  I want small reports with a "Read more" button
  To keep reports brief with the option to read on if I am really interested

  @javascript
  Scenario: Expand a question/answer in the website report
    Given we have an active text component with these question/answers:
      | Question            | Answer                    |
      | chicken cross road? | To get to the other side. |
    When I read the report
    And I click the button labeled with the question
    Then the button disappears and the answer shows up

  @javascript
  Scenario: Many threads of question/answers can be visible at once, but only the next question of the thread
    Given we have different text components, each having question/answers
    And based on the input data, the current report might look like this:
    """
    News from Bertha the cow
    [...]
    I gave eleven liters of milk today. (* Is this a lot?)
    It was hot and stuffy in the stable. (* How hot was it?)
    I hope it gets colder tomorrow.
    """
    When I click on the question "(* Is this a lot?)"
    Then the text expands like this:
    """
    News from Bertha the cow
    [...]
    I gave eleven liters of milk today. I would say, that's quite a lot. (* Want more?)
    It was hot and stuffy in the stable. (* How hot was it?)
    I hope it gets colder tomorrow.
    """

