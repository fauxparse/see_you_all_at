Feature: View profile
  In order to check myself out
  As a user
  I want to view my profile

  Scenario: View my own profile
    Given I am logged in
    When I visit my profile page
    Then I should see my name

  Scenario: View someone else's profile
    Given I am logged in
      And another user exists
     When I visit their profile
     Then I should not be allowed access

  Scenario: View someone else's profile
    Given I am logged in as an admin
      And another user exists
     When I visit their profile
     Then I should see their name
