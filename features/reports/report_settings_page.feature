Feature: Report Settings page
  As a journalist
  I want to have a settings page for my live report
  To change settings regarding the whole experiment, e.g. start date, publishing, social media

  Background:
    Given I am the journalist
    And my current live report is called "Me Wired"
    When I visit the landing page
    And I select "Me Wired" from the settings in my dashboard
    And I click on "Edit"

  @25
  Scenario: Set the start date of the experiment
    When I choose "15 June 2016" to be the start date for the experiment
    And I click on update
    Then the live report about "Me Wired" will start on that date

  @82
  Scenario: Set the start date of the experiment
    When I change the name of the report to "Very good report"
    And I click on update
    Then I see the new name in the settings menu above
