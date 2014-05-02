FactoryGirl.define do
  factory :kyu_entry do |kyu|
    kyu.association :user
    kyu.subject { Faker::Name.name }
    kyu.content { Faker::Name.name }
  end
end

