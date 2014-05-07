FactoryGirl.define do
  factory :post do
    association :user
    subject { Faker::Name.name }
    content { Faker::Name.name }
    created_at { Time.now }

    before(:create) do
      fetch_activity_type('post.create')
    end
  end
end
