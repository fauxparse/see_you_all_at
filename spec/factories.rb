FactoryGirl.define do
  activity_types = %w(activity outing occasion soiree party)

  sequence(:name) { |n| "User #{n}" }
  sequence(:email) { |n| "user_#{n}@example.com" }
  sequence(:event_name) { |n| "Event #{n}" }
  sequence(:package_name) { |n| "Package #{n}" }
  sequence(:activity_type_name) { |n| activity_types[n % activity_types.size] }

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

  factory :activity_type do
    event
    name { generate(:activity_type_name) }
  end

  factory :registration do
    user
    package
  end
end
