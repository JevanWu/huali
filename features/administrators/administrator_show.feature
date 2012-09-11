Feature: Show Administrators
  As a visitor to the website
  I want to see registered administrators listed on the homepage
  so I can know if the site has administrators

    Scenario: Viewing administrators
      Given I exist as a administrator
      When I look at the list of administrators
      Then I should see my name
