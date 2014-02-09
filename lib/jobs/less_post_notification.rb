class LessPostNotification
  @queue = "less_post_mail"
  def self.perform(user)
    UserMailer.less_post_notification(user).deliver
    puts "Sending mail"
  end
end