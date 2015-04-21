class NotificationAlert
  def self.send_notifications(rule)
    case rule["rule_for"]
    when "post" then post_alert(rule)
    when "general" then general_alert(rule)
    end
  end

  def self.post_alert(rule)
    users = User.within_rule_range(rule)
    users.each { |user| UserMailer.post_rule_notification(user, rule).deliver }
  end

  def self.general_alert(rule)
    recent_activities = Activity.from_past_24_hrs
    top_5_contributors = User.top
    User.find_in_batches(batch_size: 10) do |users|
      users.each do |user|
        UserMailer.general_rule_notification(user, rule,
          recent_activities, top_5_contributors).deliver
      end
    end
  end
end
