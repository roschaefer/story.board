@87
Feature: Choose only one heading
  As a journalist
  I want the text generator to select only one heading for the final report, based on priority
  Because every text has just one heading

  Background:
    Given there is a sensor live report
    And I am the journalist

  Scenario: The highest prioritized heading is chosen for the report
    Given I have these text components with their highest priority:
      | Heading                                   | Highest priority |
      | Using headings in your report             | high             |
      | Recommended Headings for Business Reports | low              |
    When I visit the landing page
    Then I should see:
    """
    Using headings in your report
    """
    But I should NOT see:
    """
    Recommended Headings for Business Reports
    """

  Scenario: In case of a draw, chose a heading randomly
    Given I have these text components with their highest priority:
      | Heading                                   | Highest priority |
      | Using headings in your report             | high             |
      | Basic report structure                    | high             |
      | Recommended Headings for Business Reports | medium           |
    When I visit the landing page
    Then I should see only one of the following:
    """
    Using headings in your report
    [OR]
    Basic report structure
    """
    But I should NOT see:
    """
    Recommended Headings for Business Reports
    """


