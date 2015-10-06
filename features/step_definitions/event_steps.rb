Given(/^an event exists$/) do
  @event = FactoryGirl.create(:event)
  @event.packages.create(name: I18n.t("packages.new.default", position: 0))
end

Given(/^an event exists with (\d+) packages?$/) do |n|
  step("an event exists")
  (n.to_i - 1).times { FactoryGirl.create(:package, event: @event) }
end

Given(/^I am an event administrator$/) do
  step("I am an existing user") unless @user
  step("an event exists")
  Administrator.create(user: @user, event: @event)
end

Given(/^I am logged in as an event administrator$/) do
  step("I am logged in")
  step("I am an event administrator")
end

When(/^I visit the new event page$/) do
  visit(new_event_path)
end

When(/^I visit the event's page$/) do
  visit(event_path(@event))
end

When(/^I visit the event settings page$/) do
  visit(edit_event_path(@event))
end

When(/^I enter (?:my|the) event details$/) do
  @event ||= FactoryGirl.build(:event).tap(&:validate)
  fill_in("Name", with: @event.name)
  fill_in("URL", with: @event.slug)
  fill_in("Start date", with: @event.starts_on)
  fill_in("End date", with: @event.ends_on)
end

When(/^I enter a new event name$/) do
  @new_event_name = "New event name"
  fill_in("Name", with: @new_event_name)
end

Then(/^I should be on the event's page$/) do
  expect(page.current_path).to eq(event_path(@event))
end

Then(/^I should be on the new event page$/) do
  expect(page.current_path).to eq(new_event_path)
end

Then(/^I should be on the event settings page$/) do
  expect(page.current_path).to eq(edit_event_path(@event))
end

Then(/^I should see the event's name$/) do
  expect(page).to have_content(@event.name)
end

Then(/^I should see the new event name$/) do
  expect(page).to have_content(@new_event_name)
end

Then(/^the event should have been updated$/) do
  @event.reload
  expect(@event.name).to eq(@new_event_name)
end
