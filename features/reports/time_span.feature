Feature: Time span

  Background:
    Given the sensor live report started on "2017-08-19"
    And I have these text components with the corresponding schedule in my database:
        | Text component                  | From day | To day |
        | This will come first.           | 0        | 20     |
        | This will come next.            | 20       | 40     |
        | This will come last.            | 40       | -      |
        | Something that is always there. | -        | -      |

  Scenario: Visit diary entry of day 15 
    When I visit "/reports/present/1/?at=2017-09-05T12:00+02:00"
    And I see the current live report:
    """
    This will come first.[...]Something that is always there.
    """
    But I should NOT see:
    """
    This will come next.
    [or]
    This will come last
    """

  Scenario: Visit diary entry of day 42 
    When I visit "/reports/present/1/?at=2017-09-30T12:00+02:00"
    Then I see the current live report:
    """
    This will come last.[...]Something that is always there.
    """
    But I should NOT see:
    """
    This will come first.
    [or]
    This will come next.
    """
