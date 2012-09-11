Feature: Sign out
  To protect my account from unauthorized access
  As an signed in administrator
  Should be able to sign out

    Scenario: Administrator signs out
      Given I am logged in
      When I sign out
      Then I should see a signed out message
      When I return to the site
      Then I should be signed out
