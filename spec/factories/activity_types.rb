FactoryGirl.define do
  factory :activity_type do
    sequence(:activity_type) { |n| "test#{n}" }
    is_active true

    factory :inactive do
      is_active false
    end
  end
end
