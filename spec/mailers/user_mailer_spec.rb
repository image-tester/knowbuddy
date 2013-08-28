require "spec_helper"

describe UserMailer do

  before :each do
    User.delete_all!
    @user_1 = User.create(name: 'User1', email: 'test@kiprosh.com', password: 'password', 
      password_confirmation: 'password')
    @user_2 = User.create(name: 'User2', email: 'inactive@kiprosh.com', password: 'inactive',
      password_confirmation: 'inactive')
    @user_2.deleted_at = Time.now
    @user_2.save
    @kyu_entry = KyuEntry.create(subject: 'Swimming', content: 'freestyle', user_id: @user_1.id)
    @comment = Comment.create(user_id: @user_1.id, comment: 'Good Info', kyu_entry_id: @kyu_entry.id)
  end

  describe "send notification on new Comment " do
    let(:mail) { UserMailer.send_notification_on_new_Comment(User.all, @comment) }
    it "inactive user should not receive notification email" do
      mail.subject.should eq(@user_1.name + " posted a comment for " + @kyu_entry.subject)
      mail.bcc.first.should eq(@user_1.email)
      mail.bcc.second.should_not eq(@user_2.email)
    end
  end

  describe "send notification on new KYU " do
    let(:mail) { UserMailer.send_notification_on_new_KYU(User.all, @kyu_entry) }
    it "inactive user should not receive notification email" do
      mail.subject.should eq(@user_1.name + " posted a new article on KnowBuddy")
      mail.bcc.first.should eq(@user_1.email)
      mail.bcc.second.should_not eq(@user_2.email)
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
end

