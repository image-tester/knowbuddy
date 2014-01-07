# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rule_engine do
    name "MyString"
    rule_for "MyString"
    min_post 1
    frequency "MyString"
    schedule "MyString"
    mail_for "MyString"
    active false
  end
end
