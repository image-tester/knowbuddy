namespace :populate do
  desc "Populate rules"
  task rules: :environment do
    puts "Start rake task..."

    puts "Adding rule for 'NO post in last 1 week'"
    RuleEngine.create(
      rule: "No post in 1 week",
      rule_for: "post",
      frequency: "weekly",
      schedule: "Monday",
      min_count: 0,
      max_count: 1,
      max_duration: "week",
      subject: "Your knowbuddy is waiting for you!",
      body: "This is a reminder email to let you know that you have\
        not posted any article in Knowbuddy in last 1 week",
      active: false
      )

    puts "Adding rule for '1-4 posts in last 2 weeks'"
    RuleEngine.create(
      rule: "1-4 posts in 2 weeks",
      rule_for: "post",
      frequency: "once_in_2_weeks",
      schedule: "Monday",
      min_count: 1,
      max_count: 5,
      max_duration: "2_weeks",
      subject: "Please share your knowledge in knowbuddy!",
      body: "This is a reminder email to let you know that you have\
        posted less than 5 articles in Knowbuddy in last 2 weeks.\
        Please share if you learned something new recently!",
      active: false
      )

    puts "Adding rule for '5-9 posts in last 2 weeks'"
    RuleEngine.create(
      rule: "5-9 posts in month",
      rule_for: "post",
      frequency: "monthly",
      schedule: "Monday",
      min_count: 5,
      max_count: 10,
      max_duration: "month",
      subject: "Please enrich your knowbuddy more!",
      body: "Thank you for your constant support to your knowledge\
        buddy.You have posted more than 5 articles in last 1 month.\
        Keep it up!",
      active: false
      )
    puts "Ending rake task..."
  end
end
