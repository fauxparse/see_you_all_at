Feature: Sign up for the application
  In order to use the application
  As a new User
  I want to sign up

  Scenario: Sign up
    Given I am a new user
     When I visit the home page
      And I click the "Sign up" link
     Then I should be on the signup page

     When I fill in good details for my new account
      And I click the "Sign up" button
     Then I should be on the home page
      And I should see "activate your account"
      And I should receive an email

     When I open the email
      And I follow "Confirm my account" in the email
      And I log in
     Then I should be on the home page
     Then I should see my name
