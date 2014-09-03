FactoryGirl.define do
  factory :activity do
    association :activity_type
    key "test.create"
  end
end
