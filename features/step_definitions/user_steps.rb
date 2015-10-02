Given(/^another user exists$/) do
  @another_user = FactoryGirl.create(:user)
end

When(/^I visit my profile page$/) do
  visit(user_path(@user))
end

When(/^I visit their profile$/) do
  visit(user_path(@another_user))
end

Then(/^I should see their name$/) do
  expect(page).to have_content(@another_user.name)
end
