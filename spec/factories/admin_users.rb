# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_user do
    sequence(:email) { |n| "admin_#{n}@example.com" }
    password "password"
    password_confirmation "password"
  end
end
