require "rails_helper"

describe UserMailer do

  before do
    @user_1 = create :user, name: "John"
    @user_2 = create :user
    @user_3 = create :user
    @user_2.delete!
    @post = create :post, user: @user_1
    @comment = create :comment, user: @user_1, post: @post
    @mail_receivers = User.where("id <> ?", @post.user_id)
  end

  describe "send notification on new Comment " do
    let(:mail) { UserMailer.send_notification_on_new_Comment(@mail_receivers, @comment) }
    it "inactive user should not receive notification email" do
      expect(mail.subject).to eq(@user_1.name + " posted a comment for " + @post.subject)
      expect(mail.bcc.first).to eq(@user_3.email)
      expect(mail.bcc.second).to_not eq(@user_2.email)
    end

    it "User who posted comment should not receive mail" do
      expect(mail.subject).to eq(@user_1.name + " posted a comment for " + @post.subject)
      expect(mail.bcc.include?(@user_1.email)).to eq false
    end
  end

  describe "send notification on new Post " do
    let(:mail) { UserMailer.send_notification_on_new_Post(@mail_receivers, @post) }
    it "inactive user should not receive notification email" do
      expect(mail.subject).to eq(@user_1.name + " posted a new article on KnowBuddy")
      expect(mail.bcc.first).to eq(@user_3.email)
      expect(mail.bcc.second).to_not eq(@user_2.email)
    end

    it "User who posted post should not receive mail" do
      expect(mail.subject).to eq(@user_1.name + " posted a new article on KnowBuddy")
      expect(mail.bcc.include?(@user_1.email)).to eq false
    end
  end

  describe "send welcome notification" do
    let(:mail) { UserMailer.welcome_email(@user_1) }
    it "new user should receive welcome notification email" do
      expect(mail.subject).to eq("Welcome to KnowBuddy")
    end
  end

  describe "send password changed notification" do
    let(:mail) { UserMailer.password_changed_email(@user_1) }
    it "user should receive notification on successfull change of password" do
      expect(mail.subject).to eq("Successfully resetted your password")
    end
  end

  describe "send mail to user for no post on knowbuddy" do
    let(:mail) { UserMailer.no_post_notification(@user_3) }
    it "user should receive notification mail for no post" do
      expect(mail.subject).to eq("Your knowledge buddy is waiting for you")
    end
  end

  describe "send mail to user for less then five post on knowbuddy" do
    let(:mail) { UserMailer.less_post_notification(@user_1) }
    it "user should receive notification mail for less post" do
      expect(mail.subject).to eq("Please share your knowledge in Knowbuddy")
    end
  end
end

