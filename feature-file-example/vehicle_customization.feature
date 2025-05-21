Feature: Vehicle customization
    As a potential customer
    I want to customize the vehicle I'm interested in
    So that I can see different options

  Scenario Outline: Customize suvs and <vehicleName>
    Given I am on the customize page for a "<vehicleName>" "<vehicleType>"
    When I select "Interior" tab
    Then I expect that the interior preview image changes according to the selected color
    When I select "Exterior" tab
    When I selects a random wheel option
    When I select the 360 option on the preview
    Then I expect to be able to see the car from different angles
    #Interior color
    When I select "<seatColor>" as seat color
    Then I expect the seats image to be updated
    # Interior features vide
    When I click on the Interior features button
    Then I expect to see the Internal Features section expanded
    Examples:
    | vehicleName | vehicleType | seatColor             |
    | tucson-2023 | suv         | Black monotone leather|
    | accent      | cars        | Gray                  |
    | elantra-2023| cars        | Sage Green            |

  Scenario: Customize Santa Fe
    Given I am on the customize page for a "santafe-2023" "suv"
    When I select "Interior" tab
    Then I expect that the interior preview image changes according to the selected color
    When I select "Exterior" tab
    When I selects a random wheel option
    When I select the 360 option on the preview
    Then I expect to be able to see the car from different angles
    # Seats are not customizable for Santa fe
