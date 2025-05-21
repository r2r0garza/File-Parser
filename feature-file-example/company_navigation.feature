
Feature: Company Menu Navigation

Scenario Outline: User navigates through Company menu sections
 Given User is on the home page
 When the user navigates to the "<section>" page
 Then the page should load correctly and display the expected content
 Examples:
 | section            |
 | Philosophy         |
 | Sustainability     |
 | Innovation         |
 | InvestorRelations  |
 | Metaverse          |
 | GlobalDistributors |
 | ContactUs          |
