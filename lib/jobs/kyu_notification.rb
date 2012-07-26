class KyuNotification
  @queue = "kyu_mail_queue"
  def self.perform(users, kyu_entry)
    UserMailer.send_notification_on_new_KYU(users, kyu_entry).deliver
    puts "Sending mail"
  end
end
