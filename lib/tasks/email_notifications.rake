namespace :email do
  desc "To apply rules for sending mails to users according to schedule"
  task apply_rules: :environment do
    all_active_rules = RuleEngine.active
    all_active_rules.each do |rule|
      if Utility.schedule_for_today?(rule.frequency, rule.schedule)
        puts rule.rule
        Resque.enqueue(Notification, rule)
      end
    end
  end
end

