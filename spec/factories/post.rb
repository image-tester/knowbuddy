FactoryGirl.define do
  factory :post do
    association :user
    subject { Faker::Name.name }
    content { Faker::Name.name }
    created_at { Time.now }
    tag_list { Faker::Name.name }

    before(:create) do
      fetch_activity_type('post.create')
      fetch_activity_type('post.newTag')
    end
  end
end
