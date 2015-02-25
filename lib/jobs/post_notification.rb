class PostNotification
  @queue = "kyu_mail_queue"
  def self.perform(users, post)
    UserMailer.send_notification_on_new_Post(users, post).deliver
    UserMailer.flowdock_notification(post).deliver if Rails.env.production?
    puts "Sending mail"
  end
end
