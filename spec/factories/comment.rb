FactoryGirl.define do
  factory :comment do
    association :kyu_entry
    association :user
    comment { Faker::Name.name }

    before(:create) do
      fetch_activity_type('comment.create')
    end
  end
end
