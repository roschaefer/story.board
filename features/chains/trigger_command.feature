@142
Feature: Trigger command
  As a journalist
  I want to trigger a command if a tweet relates to the action of an actuator
  To let the reader influence the experiment via twitter

  Background:
    Given there is a sensor live report

  Scenario: Automatically create a command
    Given there is an actuator called "Self-Destruction" connected at port "4"
    And I have configured this chain:
      | Actuator         | Function | Hashtag       |
      | Self-Destruction | activate | #end_of_world |
    When we receive this tweet from user @vicari for hashtag "#end_of_world":
    """
    Hey guys! Today it's the #end_of_world as we know it. Enjoy!
    """
    Then the following command is appended:
      | Actuator         | Function | Status  |
      | Self-Destruction | activate | pending |

