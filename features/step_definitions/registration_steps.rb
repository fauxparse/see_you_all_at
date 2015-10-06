When(/^I enter my registration details$/) do
  step("I fill in good details for my new account")
end

When(/^I select the first package$/) do
  choose("registration_package_slug_#{@event.packages.first.slug}")
end

Then(/^I am on the registration details page$/) do
  expect(page.current_path).to eq(event_registration_path(@event))
end
