Feature: Forgot password
  In order to log in
  As a forgetful User
  I want to recover from having lost my password

  Scenario: Forgot Password
    Given I am an existing user
     When I visit the login page
      And I click the "Forgot your password?" link
     Then I should be on the password recovery page

     When I enter my email address
      And I click the "Send" button
     Then I should be on the login page
      And I should see "instructions"
      And I should receive an email with the subject "password instructions"

     When I open the email with the subject "password instructions"
      And I click the first link in the email
     Then I should be on the edit password page

     When I choose a new password
      And I click the "Change my password" button
     Then I should be on the home page
      And I should see "signed in"
