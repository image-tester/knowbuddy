require 'spec_helper'

describe AttachmentsController do

  before do
    user = create :user
    post = create :post, user: user
    sign_in user

    file = File.new('spec/fixtures/docs/sample.txt')
    2.times { Attachment.create(kyu: file, post_id: post.id) }
  end

  describe "Delete attachments" do
    it "should delete attachments" do
      put :destroy, id: Attachment.first.id
      Attachment.all.count.should == 1
    end
  end
end
