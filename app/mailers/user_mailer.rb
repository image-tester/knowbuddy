class UserMailer < ActionMailer::Base
  add_template_helper(MailHelper)
  add_template_helper(ApplicationHelper)
  layout "notification_email"
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
    @url = APP_CONFIG["url"]
    post = Post.find(comment["post_id"])
    @link_to_post = user_post_url(post)
    @users_list = users.map{|user| user["email"]}
    @user_name = comment_user.name.try(:titleize) || comment_user.email
    @subject = @user_name + " posted a comment for " + post.subject
    mail(bcc: @users_list, subject: @subject)
  end

  def send_notification_on_new_Post(users, post)
    @content = RedCloth.new(post["content"]).to_html
    post_user = User.find(post["user_id"])
    @url = APP_CONFIG["url"]
    post = Post.find(post["id"])
    @link_to_post = user_post_url(post)
    @users_list = users.map{|user| user["email"]}
    @subject_name = post["subject"]
    user_name = post_user.name.try(:titleize) || post_user.email
    @subject = user_name + " posted a new article on KnowBuddy"
    mail(bcc: @users_list, subject: @subject)
  end

  def post_rule_notification(user, rule)
    @user = user
    @rule = rule
    send_mail(@user, @rule["subject"])
  end

  def general_rule_notification(user, rule, recent_activities, top_5)
    @activities = recent_activities
    @rule = rule
    @user = user
    @top_5 = top_5
    send_mail(@user, @rule["subject"])
  end

  def send_mail(user, subject)
    if(Rails.env == "development")
      mail(to: EMAIL_TO_SENDTO_IN_DEVLOPMENT_MODE, subject: subject)
    else
      mail(to: user["email"], subject: subject)
    end
  end

  def user_post_url(post)
    APP_CONFIG["url"] + post_path(post)
  end

  def app_login_url
    APP_CONFIG["url"] + "/users/sign_in"
  end

  def flowdock_notification(post)
    post = Post.find(post["id"])
    body = post.user.display_name +
      " posted a new article on KnowBuddy: \n#{post.subject}"
    mail(to: KIPROSH_MAIN_FLOW_EMAIL, subject: "Knowbuddy Post") do |format|
      format.text { render text: body }
    end
  end
end
