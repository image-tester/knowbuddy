require "faker"

FactoryGirl.define do
  factory :comment do |comment|
    comment.association :kyu_entry
    comment.association :user
    comment.comment                   { Faker::Name.name }
  end
end

