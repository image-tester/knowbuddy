class NoPostNotification
  @queue = "no_post_mail"
  def self.perform(users)
    UserMailer.no_post_notification(user).deliver
    puts "Sending mail"
  end
end
