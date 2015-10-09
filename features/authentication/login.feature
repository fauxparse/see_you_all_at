Feature: Login
  In order to use the application securely
  As a user
  I want to log in

  Scenario: Log in and proceed directly to secure content
    Given I am an event administrator
      And I am not logged in
     When I visit the event settings page
     Then I should see "log in or sign up"

     When I enter my login details
      And I click the "Log in" button
     Then I should be on the event settings page
