class UserMailer < ActionMailer::Base
  default from: "notifications@kiprosh.com"

  def welcome_email(user)
    @user = user
    @url = APP_CONFIG['url'] + "/users/sign_in"
    mail(to: user["email"], subject: "Welcome to KnowBuddy")
  end

  def password_changed_email(user)
    @user = user
    @url = APP_CONFIG['url'] + "/users/sign_in"
    mail(to: user["email"], subject: "Successfully resetted your password")
  end

  def send_notification_on_new_Comment(users, comment)
    @comment = comment["comment"]
    kyu_comment = User.find_by_id(comment["user_id"])
    posted_by = kyu_comment.email
    name = kyu_comment.name.titleize if kyu_comment.name
    @url = APP_CONFIG['url']
    kyu = KyuEntry.find_by_id(comment["kyu_entry_id"])
    @link_to_comment = @url + kyu_entry_path(kyu)
    @users_list = []
    users.each do |user_to_notify|
      @users_list << user_to_notify["email"]
    end
    @user_name = name ? name : posted_by
    @subject = @user_name + " posted a comment for " + kyu.subject
    mail(bcc: @users_list, subject: @subject)
  end

  def send_notification_on_new_KYU(users, kyu_entry)
    @content = RedCloth.new(kyu_entry["content"]).to_html
    kyu_user = User.find_by_id(kyu_entry["user_id"])
    posted_by = kyu_user.email
    name = kyu_user.name.titleize if kyu_user.name
    @url = APP_CONFIG['url']
    kyu = KyuEntry.find_by_id(kyu_entry["id"])
    @link_to_kyu = @url + kyu_entry_path(kyu)
    @users_list = []
    users.each do |user_to_notify|
      @users_list << user_to_notify["email"]
    end
    @subject_name = kyu_entry["subject"]
    user_name = name ? name : posted_by
    @subject = user_name + " posted a new article on KnowBuddy"
    mail(bcc: @users_list, subject: @subject)
  end

  def no_post_notification(user)
    @user = user
    @subject = "Your knowledge buddy is waiting for you"
    @url = APP_CONFIG['url'] + "/users/sign_in"
    send_mail(@user, @subject)
  end

  def less_post_notification(user)
    @user = user
    @url = APP_CONFIG['url'] + "/users/sign_in"
    @subject = "Please share your knowledge in Knowbuddy"
    send_mail(@user, @subject)
  end

  def send_mail(user, subject)    
    (Rails.env == "development") ? mail(to: EMAIL_TO_SENDTO_IN_DEVLOPMENT_MODE, subject: subject) : 
                                   mail(to: user["email"], subject: subject)
  end

end
