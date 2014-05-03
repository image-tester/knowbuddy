FactoryGirl.define do
  factory :kyu_entry do
    association :user
    subject { Faker::Name.name }
    content { Faker::Name.name }
    created_at { Time.now }

    before(:create) do
      fetch_activity_type('kyu_entry.create')
    end
  end
end
