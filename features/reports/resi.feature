@206 @wip
Feature: Read more button
  As a reader who is sometimes more, sometimes less interested
  I want small reports with a "Read more" button
  To keep reports brief with the option to read on if I am really interested

  @javascript
  Scenario: Expand a question/answer in the website report
    Given we have an active text component with these question/answers:
      | Question                            | Answer                    |
      | Why did the chicken cross the road? | To get to the other side. |
    When I read the report
    And I click the button labeled with the question
    Then the button disappears and the answer shows up
