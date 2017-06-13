Feature: Generate a Sensorstory for every Report
  As a reporter
  I want to have a sensorstory generated for every of my reports
  in order to write different Sensorstories.


  Scenario:
    Given we have these text components:
      | Text component                  | Report       |
      | It's about sensory data         | Sensor story |
      | Robots are conquering the world | Robot story  |
    When I visit the landing page
    And switch to report "Sensor story"
    Then I will see a different generated text as if I would switch to "Robot story"
