@83
Feature: Render Custom Variables in Text Component Markup
  As a reporter
  I want to render custom variables in the markup of the report
  To reference report-specific information in text components


  Background:
    Given my current live report is called "The Experiment"

  Scenario: Write about report
    Given there is an active text component with the following main part:
    """
    Today is a good day for "{ report }".
    """
    When I visit the landing page
    Then I should see:
    """
    Today is a good day for "The Experiment".
    """

  Scenario: Write about custom variables
    Given I have these custom variables for my report
      | Key    | Value |
      | person | Peter |
    Given there is an active text component with the following main part:
    """
    When { person } woke up this morning, he was very tired.
    """
    When I visit the landing page
    Then I should see:
    """
    When Peter woke up this morning, he was very tired.
    """
