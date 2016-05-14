Feature: Show Report on Landing Page
  As a reader
  I want to read the latest generated report on the landing page
  Because I'm interested to see what happened in the experiment recently

  Scenario: Visit Landing Page
    When I visit the landing page
    Then I should see:
    """
    This is the live report of your experiment
    """
