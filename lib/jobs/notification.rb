class Notification
  @queue = "notification_alert"
  def self.perform(rule)
    puts "notification_alert sent"
    NotificationAlert.send_notifications(rule)
  end
end
