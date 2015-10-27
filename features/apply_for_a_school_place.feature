Feature: Apply for a school place
  As an applicant for a school place for a child in my care
  I want to see the nearest schools to where I live
  So that I can apply to schools I have a chance of getting into

  @javascript
  Scenario: Seeing a map based on postcode and house number
    Given there are some schools
    When I visit the apply schools page
    And I enter a valid postcode and house number
    Then I should see a map with my home
    And I should see my five nearest community schools
    And I should see other own admission schools
