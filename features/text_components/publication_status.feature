@311
Feature: Only published text components should used to generate a report
  As a reporter
  I want to have a flag for text.components (draft, fact-checked, published) and only published text components should be included in the report
  In order to add new text components without affecting the result of the live report

  Background:
    Given there is a sensor live report
  
  Scenario:
    Given there is an unpublished text component with the following main part:
    """
    I am currently unpublished.
    """
    And there is a triggered text component with the following main part:
    """
    Yeah, I am finally published!
    """
    When I visit the landing page
    Then I should see:
    """
    Yeah, I am finally published!
    """
    But I should NOT see:
    """
    I am currently unpublished.
    """
