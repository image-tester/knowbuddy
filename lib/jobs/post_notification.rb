class PostNotification
  @queue = "kyu_mail_queue"
  def self.perform(users, post)
    UserMailer.send_notification_on_new_Post(users, post).deliver
    puts "Sending mail"
  end
end
