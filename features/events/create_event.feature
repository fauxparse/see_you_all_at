Feature: Create an event
  In order to manage registrations for my event
  As a user
  I want to create an event

  Scenario: Create an event
    Given I am logged in
     When I visit the new event page
      And I enter my event details
      And I click the "Create event" button
     Then I should be on the event settings page
      And I should see the event's name

  Scenario: Attempt to create an event when not logged in
    Given I am not logged in
     When I visit the new event page
     Then I should be prompted to log in

  Scenario: Attempt to create an event that already exists
    Given I am logged in
      And an event exists
     When I visit the new event page
      And I enter the event details
      And I click the "Create event" button
     Then I should see "URL has already been taken"
