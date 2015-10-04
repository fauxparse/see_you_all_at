Given(/^an event exists$/) do
  @event = FactoryGirl.create(:event)
end

When(/^I visit the new event page$/) do
  visit(new_event_path)
end

When(/^I enter (?:my|the) event details$/) do
  @event ||= FactoryGirl.build(:event).tap(&:validate)
  fill_in("Name", with: @event.name)
  fill_in("URL", with: @event.slug)
  fill_in("Start date", with: @event.starts_on)
  fill_in("End date", with: @event.ends_on)
end

Then(/^I should be on the event's page$/) do
  expect(page.current_path).to eq(event_path(@event))
end

Then(/^I should be on the new event page$/) do
  expect(page.current_path).to eq(new_event_path)
end

Then(/^I should see the event's name$/) do
  expect(page).to have_content(@event.name)
end
