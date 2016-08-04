Feature:Embed Livestream
  As a reader,
  I want to have a webcam livestream embedded in the report
  To watch the experiment live

  Scenario: Add a video and watch it on the landing page
    Given I am the journalist
    And my current live report is called "Big Brother"
    And I select "Big Brothers" from the settings in my dashboard
    When I add a video URL to the report
    And I visit the landing page
    Then I can watch a video stream that points to this url


