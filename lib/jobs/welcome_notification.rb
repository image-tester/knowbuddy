class WelcomeNotification
  @queue = "welcome_mail"
  def self.perform(user)
    UserMailer.welcome_email(user).deliver
    puts "Sending mail"
  end
end
