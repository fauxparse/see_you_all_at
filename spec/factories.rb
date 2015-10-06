FactoryGirl.define do
  sequence(:name) { |n| "User #{n}" }
  sequence(:email) { |n| "user_#{n}@example.com" }
  sequence(:event_name) { |n| "Event #{n}" }
  sequence(:package_name) { |n| "Package #{n}" }

  factory :user do
    name
    email
    password "4l0h0m0r4"
    password_confirmation "4l0h0m0r4"
  end

  factory :event do
    name { generate(:event_name) }
    starts_on "2015-04-01"
    ends_on "2015-04-04"
  end

  factory :administrator do
    user
    event
  end

  factory :package do
    event
    name { generate(:package_name) }
  end

  factory :registration do
    user
    package
  end
end
