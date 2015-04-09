namespace :email do
  desc "To check rule"
  task check_rule: :environment do
    all_active_rules = RuleEngine.active
    all_active_rules.each do |rule|
      if Utility.schedule_for_today?(rule.frequency, rule.schedule)
        puts rule.rule
        Resque.enqueue(Notification, rule)
      end
    end
  end
end

