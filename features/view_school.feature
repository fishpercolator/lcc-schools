Feature:
  As a parent of a school-age child
  I want to view details about a single school
  So that I can understand how admissions were made for that school

  Scenario: Viewing a school with priorities
    Given there is a school with some priority data
    When I visit that school's page
    Then I should see that school's details
    And I should see a graph showing how places were allocated by priority
    And I should see help for each of the priorities
