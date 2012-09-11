Feature: Edit Administrator
  As a registered administrator of the website
  I want to edit my administrator profile
  so I can change my administratorname

    Scenario: I sign in and edit my account
      Given I am logged in
      When I edit my account details
      Then I should see an account edited message
