Feature: Report Settings page
  As a journalist
  I want to have a settings page for my live report
  To change settings regarding the whole experiment, e.g. start date, publishing, social media

  Scenario:
    Given I am the journalist
    And my current live report is called "Me Wired"
    When I visit the landing page
    And I select "Me Wired" from the settings in my dashboard
    And I click on "Edit"
    And I choose "15 June 2016" to be the start date for the experiment
    And I click on update
    Then the live report about "Me Wired" will start on that date
