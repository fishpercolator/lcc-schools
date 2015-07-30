Feature:
  As a parent of a school-age child
  I want to explore schools and facts about admissions
  So that I can understand why a decision has been made

Background:
  Given there are some schools

@javascript
Scenario: Filtering the schools
  When I visit the explore schools page
  Then I should see a map of all the schools
  And I should see a list of all the schools with coloured badges indicating whether they were oversubscribed
  When I filter by community admission policy
  Then I should see only schools with a community admission policy
