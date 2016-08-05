@83
Feature: Include Report name in Text Component Markup
  As a reporter I want to
  have the markup "{exemplar}" replaced with the name of the report
  to use a text component for different reports


  Background:
    Given my current live report is called "The Experiment"

  Scenario: Include markup in text component
    Given there is an active text component with the following main part:
    """
    Today is a good day for "{ report }".
    """
    When I visit the landing page
    Then I should see:
    """
    Today is a good day for "The Experiment".
    """
