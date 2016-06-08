Feature: Text components: Priorities
  As a journalist
  I want to store priorities for text components
  So the sensor.bot can make a selection if not all text components fit into a report


  Background:
    Given there is a sensor live report

  Scenario: Edit Text Component Priority
    Given I have a text component with the heading "Very Important"
    When I visit the landing page
    And I click on "Text Components" in my dashboard
    And I click on "Very Important" to view the text component
    And I click on "Edit" to change the priority
    And I select "high" from the priorities
    And I click on "Update"
    Then my heading has become very important
