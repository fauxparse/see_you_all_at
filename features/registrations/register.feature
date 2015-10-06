Feature: Register for an event
  In order to take part in an event
  As a participant
  I want to register

  Scenario: Register as a new user for an event with multiple packages
    Given I am a new user
      And an event exists with 3 packages

     When I visit the event's page
      And I click the "Register now" link
     Then I should see "Select package"

     When I select the first package
      And I click the "Continue" button
     Then I should see "log in or sign up"

     When I click the "Sign up" link
      And I fill in good details for my new account
      And I click the "Sign up" button
      And I confirm my email address
     Then I should see "registered"

  Scenario: Register as a new user for an event with a single package
    Given I am a new user
      And an event exists
     When I visit the event's page
      And I click the "Register now" link
     Then I should see "log in or sign up"

     When I click the "Sign up" link
      And I fill in good details for my new account
      And I click the "Sign up" button
      And I confirm my email address
     Then I should see "registered"

  Scenario: Register as an existing user for an event with multiple packages
    Given I am an existing user
      And an event exists with 3 packages

     When I visit the event's page
      And I click the "Register now" link
     Then I should see "Select package"

     When I select the first package
      And I click the "Continue" button
     Then I should see "log in or sign up"

     When I enter my login details
      And I click the "Log in" button
     Then I should see "registered"

  Scenario: Register as an existing user for an event with a single package
    Given I am an existing user
      And an event exists

     When I visit the event's page
      And I click the "Register now" link
     Then I should see "log in or sign up"

     When I enter my login details
      And I click the "Log in" button
     Then I should see "registered"
