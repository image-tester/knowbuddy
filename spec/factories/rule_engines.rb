FactoryGirl.define do
  factory :rule_engine do
    sequence(:rule) { |n| "testrule#{n}" }
    rule_for "posts"
    frequency "weekly"
    schedule "Thursday"
    max_duration "week"
    min_count 0
    max_count 1
    subject "RuledSubject"
    body "RuledBody"
    active true

    factory :no_post_rule do
      rule "0-1 posts"
      min_count 0
      max_count 1
      subject "Your knowledge buddy is waiting for you"
      body "Body_For_No_Post"
    end

    factory :less_post_rule do
      rule "1-4 posts"
      min_count 1
      max_count 5
      subject "Please share your knowledge in Knowbuddy"
      body "Body_For_1-4_Posts"
    end
  end
end
