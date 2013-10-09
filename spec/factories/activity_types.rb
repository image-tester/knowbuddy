# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity_type do
    activity_type "comment.create"
    is_active 1
  end
end
