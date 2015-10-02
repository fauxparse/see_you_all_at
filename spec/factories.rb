FactoryGirl.define do
  sequence(:name) { |n| "User #{n}" }
  sequence(:email) { |n| "user_#{n}@example.com" }

  factory :user do
    name
    email
    password "4l0h0m0r4"
    password_confirmation "4l0h0m0r4"
  end
end
