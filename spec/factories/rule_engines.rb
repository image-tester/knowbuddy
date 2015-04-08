FactoryGirl.define do
  factory :rule_engine do
    sequence(:rule) { |n| "testrule#{n}" }
    rule_for "post"
    frequency "weekly"
    schedule "Tuesday"
    max_duration "week"
    min_count 0
    max_count 1
    subject "RuledSubject"
    body "RuledBody"
    active true

    factory :no_post_in_week_rule do
      rule "0 posts"
      min_count 0
      max_count 1
      subject "Your knowledge buddy is waiting for you"
      body "Body_For_No_Post"
    end

    factory :one_post_in_week_rule do
      rule "1 post"
      min_count 1
      max_count 2
      subject "Please share your knowledge in Knowbuddy"
      body "Body_For_One_Post"
    end

    factory :two_post_rule do
      rule "2 post"
      min_count 2
      max_count 3
      subject "Please enrich your knowledge buddy more!"
      body "Body_For_Two_Posts"
    end
  end
end
