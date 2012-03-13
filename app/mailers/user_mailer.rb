class UserMailer < ActionMailer::Base
  default from: "notifications@kiprosh.com"
  
  def welcome_email(user)
    @user = user
    @url  = APP_CONFIG['url'] + "users/sign_in"
    mail(:to => user.email, :subject => "Welcome to KnowBuddy")
  end
  
  def send_notification_on_new_KYU(users, kyu_entry) 
    @content = kyu_entry.content
    @posted_by = kyu_entry.user
    @url  = APP_CONFIG['url']
    @link_to_kyu = @url + kyu_entry_path(kyu_entry)
    @users_list = ""
    users.each do |user_to_notify|
      @user = user_to_notify
      @users_list = @users_list + user_to_notify.email + ","
    end
    @subject = "[New KYU] " + kyu_entry.subject
    mail(:bcc => @users_list, :subject => @subject)
  end  
  
end
