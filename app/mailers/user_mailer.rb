class UserMailer < ActionMailer::Base
  default from: "notifications@kiprosh.com"

  def welcome_email(user)
    @user = user
    @url = app_login_url
    mail(to: user["email"], subject: "Welcome to KnowBuddy")
  end

  def password_changed_email(user)
    @user = user
    @url = app_login_url
    mail(to: user["email"], subject: "Successfully resetted your password")
  end

  def send_notification_on_new_Comment(users, comment)
    @comment = comment["comment"]
    comment_user = User.find(comment["user_id"])
    @url = APP_CONFIG['url']
    kyu = KyuEntry.find(comment["kyu_entry_id"])
    @link_to_comment = @url + kyu_entry_path(kyu)
    @users_list = users.pluck(:email)
    @user_name = comment_user.name.try(:titleize) || comment_user.email
    @subject = @user_name + " posted a comment for " + kyu.subject
    mail(bcc: @users_list, subject: @subject)
  end

  def send_notification_on_new_KYU(users, kyu_entry)
    @content = RedCloth.new(kyu_entry["content"]).to_html
    kyu_user = User.find(kyu_entry["user_id"])
    @url = APP_CONFIG['url']
    kyu = KyuEntry.find(kyu_entry["id"])
    @link_to_kyu = @url + kyu_entry_path(kyu)
    @users_list = users.pluck(:email)
    @subject_name = kyu_entry["subject"]
    user_name = kyu_user.name.try(:titleize) || kyu_user.email
    @subject = user_name + " posted a new article on KnowBuddy"
    mail(bcc: @users_list, subject: @subject)
  end

  def no_post_notification(user)
    @user = user
    @subject = "Your knowledge buddy is waiting for you"
    @url = app_login_url
    send_mail(@user, @subject)
  end

  def less_post_notification(user)
    @user = user
    @url = app_login_url
    @subject = "Please share your knowledge in Knowbuddy"
    send_mail(@user, @subject)
  end

  def send_mail(user, subject)    
    (Rails.env == "development") ?
      mail(to: EMAIL_TO_SENDTO_IN_DEVLOPMENT_MODE, subject: subject) :
      mail(to: user["email"], subject: subject)
  end

  def app_login_url
    APP_CONFIG['url'] + "/users/sign_in"
  end
end
