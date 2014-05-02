FactoryGirl.define do
  factory :kyu_entry do
    association :user
    subject { Faker::Name.name }
    content { Faker::Name.name }
  end
end

