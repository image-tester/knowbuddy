FactoryGirl.define do
  factory :kyu_entry do
    association :user
    subject { Faker::Name.name }
    content { Faker::Name.name }

    before(:create) do
      fetch_activity_type('kyu_entry.create')
    end
  end
end
