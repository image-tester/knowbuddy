require "faker"

FactoryGirl.define do
  factory :comment do
    association :kyu_entry
    association :user
    comment { Faker::Name.name }
  end
end
