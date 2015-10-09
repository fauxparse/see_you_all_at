Feature: Edit event settings
  In order to manage my event
  As an event administrator
  I want to edit my event's settings

  Scenario: Change event name
    Given I am logged in as an event administrator
     When I visit the event settings page
      And I enter a new event name
      And I click the "Save settings" button
     Then I should be on the event settings page
      And I should see the new event name
      And the event should have been updated
