class NotificationAlert
  def self.send_notifications(rule)
    case rule["rule_for"]
    when "post" then posts_notification(rule)
    when "general" then top_contributors_notification(rule)
    end
  end

  def self.posts_notification(rule)
    users = User.within_rule_range(rule)
    users.each { |user| UserMailer.post_rule_notification(user, rule).deliver }
  end

  def self.top_contributors_notification(rule)
    recent_activities = Activity.from_past_24_hrs
    start_date_of_contribution_period = User.
      find_gap_boundary(rule["max_duration"])
    top_contributors = User.top(start_date_of_contribution_period)
    User.find_in_batches(batch_size: 10) do |users|
      users.each do |user|
        UserMailer.general_rule_notification(user, rule,
          recent_activities, top_contributors).deliver
      end
    end
  end
end
