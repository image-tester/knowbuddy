FactoryGirl.define do
  factory :post do
    association :user
    subject { Faker::Name.name }
    content { Faker::Name.name }
    created_at { Time.now }
    is_draft false

    factory :draft do
      is_draft true
      to_create do |instance|
        instance.save(validate: false)
      end
    end

    before(:create) do
      fetch_activity_type('post.create')
    end
  end
end
