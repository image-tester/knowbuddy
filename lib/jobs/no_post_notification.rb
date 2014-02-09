class NoPostNotification
  @queue = "no_post_mail"
  def self.perform(user)
    UserMailer.no_post_notification(user).deliver
    puts "Sending mail"
  end
end
