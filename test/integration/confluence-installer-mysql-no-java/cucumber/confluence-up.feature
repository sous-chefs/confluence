Feature: The Confluence server is up

  In order to make sure that Confluence has been installed and runs
  As a developer
  I want to access Confluence's home page

  Scenario: Developer accesses the home page
    Given the url of Confluences home page
    When a web user browses to the url
    Then the page should have the title "Confluence Setup Wizard - Confluence"