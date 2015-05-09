FactoryGirl.define do
  factory :post do
    association :user
    subject { Faker::Name.name }
    content { Faker::Name.name }
    created_at { Time.now }
    tag_list { Faker::Name.name }
    is_draft false
    is_published true
    is_internal false

    factory :draft do
      is_draft true
      is_published false
      to_create do |instance|
        instance.save(validate: false)
      end
    end

    before(:create) do
      fetch_activity_type('post.create')
      fetch_activity_type('post.newTag')
    end
  end
end
