Feature: Vehicle details from Search
    As a customer
    I should be able to see the details of a searched vehicle
@vehicle_navigation
Scenario Outline: Navigate to vehicle details page
    Given User is on the home page
    When user searches for "<searchTerm>"
    And user selects a random vehicle from the results
    Then user should navigate to the vehicle details page
    And the details page should be for a "<searchTerm>" vehicle
    Examples:
    | searchTerm |
    | Tucson     |
    | Ioniq      |
    | Elantra    |
