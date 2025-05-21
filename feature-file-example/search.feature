Feature: Vehicle search
    As a user I should be able to search vehicles

  @smoke @precondition
  Scenario: Search existing vehicle
    Given User is on the home page
    When user searches for "Tucson"
    Then vehicle filter is not displayed
    And vehicle results should not be empty
    When user clears search term
    Then vehicle filter is displayed
