require "spec_helper"

describe UserMailer do

  before do
    @user_1 = create :user, name: "John"
    @user_2 = create :user
    @user_3 = create :user
    @user_2.delete!
    @kyu_entry = create :kyu_entry, user: @user_1
    @comment = create :comment, user: @user_1, kyu_entry: @kyu_entry
    @mail_receivers = User.where("id <> ?", @kyu_entry.user_id)
  end

  describe "send notification on new Comment " do
    let(:mail) { UserMailer.send_notification_on_new_Comment(@mail_receivers, @comment) }
    it "inactive user should not receive notification email" do
      mail.subject.should eq(@user_1.name + " posted a comment for " + @kyu_entry.subject)
      mail.bcc.first.should eq(@user_3.email)
      mail.bcc.second.should_not eq(@user_2.email)
    end

    it "User who posted comment should not receive mail" do
      mail.subject.should eq(@user_1.name + " posted a comment for " + @kyu_entry.subject)
      expect(mail.bcc.include?(@user_1.email)).to be_false
    end
  end

  describe "send notification on new KYU " do
    let(:mail) { UserMailer.send_notification_on_new_KYU(@mail_receivers, @kyu_entry) }
    it "inactive user should not receive notification email" do
      mail.subject.should eq(@user_1.name + " posted a new article on KnowBuddy")
      mail.bcc.first.should eq(@user_3.email)
      mail.bcc.second.should_not eq(@user_2.email)
    end

    it "User who posted post should not receive mail" do
      mail.subject.should eq(@user_1.name + " posted a new article on KnowBuddy")
      expect(mail.bcc.include?(@user_1.email)).to be_false
    end
  end

  describe "send welcome notification" do
    let(:mail) { UserMailer.welcome_email(@user_1) }
    it "new user should receive welcome notification email" do
      mail.subject.should eq("Welcome to KnowBuddy")
    end
  end

  describe "send password changed notification" do
    let(:mail) { UserMailer.password_changed_email(@user_1) }
    it "user should receive notification on successfull change of password" do
      mail.subject.should eq("Successfully resetted your password")
    end
  end

  describe "send mail to user for no post on knowbuddy" do
    let(:mail) { UserMailer.no_post_notification(@user_3) }
    it "user should receive notification mail for no post" do
      mail.subject.should eq("Your knowledge buddy is waiting for you")
    end
  end

  describe "send mail to user for less then five post on knowbuddy" do
    let(:mail) { UserMailer.less_post_notification(@user_1) }
    it "user should receive notification mail for less post" do
      mail.subject.should eq("Please share your knowledge in Knowbuddy")
    end
  end
end

