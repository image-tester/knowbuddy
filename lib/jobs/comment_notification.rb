class CommentNotification
  @queue = "comment_mail_notification"
  def self.perform(users, kyu_entry)
      UserMailer.send_notification_on_new_Comment(users, kyu_entry).deliver
    puts "Sending mail"
  end
end
