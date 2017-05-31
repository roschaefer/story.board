@311
Feature: Only published text components should be used to generate a report
  As a reporter
  I want to have a flag for text components (draft, fact-checked, published) and only published text components should be included in the report
  In order to add new text components, edit them and discuss them with other team members before they become publicly visible

  Background:
    Given there is a sensor live report
  
  Scenario:
    Given there is an unpublished text component with the following main part:
    """
    My newly created text component
    """
    When I visit the landing page
    Then I should NOT see:
    """
    My newly created text component
    """
    And I change the text component's publication status to "published"
    And I visit the landing page
    Then I should see:
    """
    My newly created text component
    """
