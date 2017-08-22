Feature: Report Settings page
  As a journalist
  I want to have a settings page for my live report
  To change settings regarding the whole experiment, e.g. start date, publishing, social media

  As a reporter
  I want to set an end date of my report
  So triggers can be aligned along a linear schedule
  For convenience, the end date could also be entered in days

  Background:
    Given I am the journalist
    And my current live report is called "Me Wired"
    When I visit the landing page
    And I navigate to the settings page
    And I click on "Edit"

  @25
  Scenario: Set the start date of the experiment
    When I choose "15 June 2016" to be the start date for the experiment
    And I click on update
    Then the live report about "Me Wired" will start on that date

  @82
  Scenario: Change name of report
    When I change the name of the report to "Very good report"
    And I click on update
    Then I see the new name in the settings menu above

  @157
  Scenario: Change the end date
    When I choose "14 June 2016" to be the start date for the experiment
    And enter "200 days" as duration for my experiment
    And I click on update
    Then I can see that my experiment will end on "2016-12-31"
