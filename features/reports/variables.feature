@82
Feature: Report: Edit Custom Variables
  As a reporter
  I want to edit custom variables of my report
  In order to change report-specific information

  Background:
    Given there is a sensor live report
    And I am the journalist

  Scenario: Change the value of a variable
    Given I have these custom variables for my report:
      | Key         | Value |
      | my_variable |       |
    When I edit the settings of my current live report
    And I fill in "my_variable" with "my value"
    And I click on "Update"
    Then I see that my custom variable "my_variable" has a value "my value"


