Feature: See edit modal in show page
  As a reporter
  I wish to have an edit button in the view of the text component (which I get to see after I created a new component)
  In order to correct mistakes.

  Scenario:
    Given I am the journalist
    Given I landed on the "/reports/1/text_components/42" page because I just edited that component
    When I click on "Edit text component"
    Then the edit modal pops up, allowing me to correct mistakes
