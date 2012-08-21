require 'spec_helper'

describe AttachmentsController do

  before :each do
    User.delete_all!
    KyuEntry.delete_all!
    @user = User.create(name: 'user1', email: 'test@kiprosh.com', password: 'password', password_conformation: 'password')
    @kyu = KyuEntry.create(subject: 'super bike', content: 'ducati', user_id: @user.id)
    sign_in @user
    file = File.new('spec/fixtures/docs/sample.txt')
    4.times do
      attached_file = Attachment.create(kyu: file, kyu_entry_id: @kyu.id)
    end
  end

  describe "Delete attachments" do
    it "should delete attachments" do
      Attachment.first.destroy
      Attachment.first.destroy
      Attachment.all.count.should == 2
    end
  end

end
