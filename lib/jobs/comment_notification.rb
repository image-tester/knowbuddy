class CommentNotification
  @queue = "comment_mail_notification"
  def self.perform(users, comment)
    UserMailer.send_notification_on_new_Comment(users, comment).deliver
    puts "Sending mail"
  end
end
