Feature: Time span

  Background:
    Given there is a sensor live report
    And I have these text components with the corresponding schedule in my database:
      | Text component                  | From day | To day |
      | This will come first.           | 0        | 20     |
      | This will come next.            | 20       | 40     |
      | Something that is always there. | 0        | 40     |

  Scenario:
    Given it's the 2nd day of the experiment
    And I visit the landing page
    And I see the current live report:
    """
    This will come first.[...]Something that is always there.
    """
    But I should NOT see:
    """
    This will come next.
    """
    When I wait for 20 days
    And I visit the landing page
    Then I see the current live report has changed to:
    """
    This will come next.[...]Something that is always there.
    """
    But I should NOT see:
    """
    This will come first.
    """
