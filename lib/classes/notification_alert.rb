class NotificationAlert
  def self.send_notifications(rule)
    post_alert(rule) if rule["rule_for"] == "post"
  end

  def self.post_alert(rule)
    users = User.within_rule_range(rule)
    users.each { |user| UserMailer.ruled_post_notification(user, rule).deliver }
  end
end
