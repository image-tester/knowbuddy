class NotificationAlert
  def self.send_notifications(rule)
    case rule["rule_for"]
    when "post" then post_alert(rule)
    end
  end

  def self.post_alert(rule)
    users = User.within_rule_range(rule)
    users.each do |user|
      UserMailer.ruled_post_notification(user, rule).deliver
    end
  end
end
