require "spec_helper"

describe UserMailer do

  before :each do
    User.delete_all!
    @user_1 = User.create(name: 'user1', email: 'test@kiprosh.com', password: 'password',
password_conformation: 'password')
    @user_2 = User.create(name: 'user2', email: 'inactive@kiprosh.com', password: 'inactive',
password_conformation: 'inactive')
    @user_2.deleted_at = Time.now
    @user_2.save
    @kyu_entry = KyuEntry.create(subject: 'Swimming', content: 'freestyle', user_id: @user_1.id)
    @comment = Comment.create(user_id: @user_1.id, comment: 'Good Info', kyu_entry_id: @kyu_entry.id)
  end

  describe "send notification on new Comment " do
    let(:mail) { UserMailer.send_notification_on_new_Comment(User.all, @comment) }
    it "inactive user should not receive notification email" do
      mail.subject.should eq("Comments posted for " + @kyu_entry.subject)
      mail.bcc.first.should eq(@user_1.email)
      mail.bcc.second.should_not eq(@user_2.email)
    end
  end

  describe "send notification on new KYU " do
    let(:mail) { UserMailer.send_notification_on_new_KYU(User.all, @kyu_entry) }
    it "inactive user should not receive notification email" do
      mail.subject.should eq("New KYU posted by " + @user_1.email)
      mail.bcc.first.should eq(@user_1.email)
      mail.bcc.second.should_not eq(@user_2.email)
    end
  end
end

