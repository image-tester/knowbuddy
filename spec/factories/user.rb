require "faker"

FactoryGirl.define do
  factory :user do |user|
    user.name                   { Faker::Name.name }
    user.email                  { Faker::Internet.email }
    user.password               "password"
    user.password_confirmation  "password"
  end
end

