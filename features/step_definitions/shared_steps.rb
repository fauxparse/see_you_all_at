When(/^I click the "(.*?)" link$/) do |link_text|
  click_link(link_text)
end

When(/^I click the "(.*?)" button$/) do |button_text|
  click_button(button_text)
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(page).to have_content(text)
end

Then(/^I should not be allowed access$/) do
  expect(page.status_code).to eq(403)
end
