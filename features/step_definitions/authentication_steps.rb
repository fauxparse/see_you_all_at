When(/^I am a new user$/) do
  @user = FactoryGirl.build(:user, name: "Hermione Granger", email: "hermione@hogwarts.ac.uk")
end

When(/^I am an existing user$/) do
  step("I am a new user")
  @user.skip_confirmation!
  @user.save!
end

When(/^I visit the home page$/) do
  visit(root_path)
end

When(/^I visit the login page$/) do
  visit(new_user_session_path)
end

When(/^I enter my name$/) do
  fill_in("Name", with: @user.name)
end

When(/^I enter my email address$/) do
  fill_in("Email", with: @user.email)
end

When(/^I fill in good details for my new account$/) do
  step("I enter my name")
  step("I enter my email address")
  fill_in("Password", with: @user.password)
  fill_in("Password confirmation", with: @user.password)
end

When(/^I choose a new password$/) do
  password = "n3wp4ssw0rd"
  fill_in("New password", with: password)
  fill_in("Confirm new password", with: password)
end

When(/^I log in$/) do
  visit(new_user_session_path)
  step("I enter my email address")
  fill_in("Password", with: @user.password)
  click_button("Log in")
end

Then(/^I should be on the home page$/) do
  expect(page.current_path).to eq(root_path)
end

Then(/^I should be on the signup page$/) do
  expect(page.current_path).to eq(new_user_registration_path)
end

Then(/^I should be on the login page$/) do
  expect(page.current_path).to eq(new_user_session_path)
end

Then(/^I should be on the password recovery page$/) do
  expect(page.current_path).to eq(new_user_password_path)
end

Then(/^I should be on the edit password page$/) do
  expect(page.current_path).to eq(edit_user_password_path)
end

Then(/^I should see my name$/) do
  expect(page).to have_content(@user.name)
end
