class PasswordNotification
  @queue = "password_changed_mail"
  def self.perform(user)
    UserMailer.password_changed_email(user).deliver
    puts "Sending mail"
  end
end
