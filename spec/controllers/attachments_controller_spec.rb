require 'spec_helper'

describe AttachmentsController do

  before do
    user = create :user
    kyu = create :kyu_entry, user: user
    sign_in user

    file = File.new('spec/fixtures/docs/sample.txt')
    2.times { Attachment.create(kyu: file, kyu_entry_id: kyu.id) }
  end

  describe "Delete attachments" do
    it "should delete attachments" do
      put :destroy, id: Attachment.first.id
      Attachment.all.count.should == 1
    end
  end
end
