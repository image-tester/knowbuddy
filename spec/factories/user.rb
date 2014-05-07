require "faker"

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"

    before(:create) do
      fetch_activity_type('user.create')
    end
  end
end

