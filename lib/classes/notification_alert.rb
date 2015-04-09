class NotificationAlert
  def self.send_notifications(rule)
    case rule["rule_for"]
    when "post" then
      post_alert(rule)
    end
  end

  def self.post_alert(rule)
    users = User.within_rule_range(rule)
    users.each do |user|
      UserMailer.ruled_post_notification(user, rule).deliver
    end
  end

  # def self.recent_activities(min_count)
  #   activities = Activity.where("updated_at <= ?", min_count.days.ago)
  #   users = User.where("id not in (?)", activities.pluck(:owner_id).uniq)
  #   users.each { |user| UserMailer.no_post_notification(user).deliver }
  # end

  # def self.top_contributors_alert(alert_type)
  #   top_users = User.top_contributors(alert_type)
  #   User.find_in_batches(batch_size: 10) do |users|
  #     users.each do |user|
  #       UserMailer.top3_contributer(user, top_users).deliver
  #     end
  #   end
  # end

end
