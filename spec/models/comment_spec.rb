require 'spec_helper'

describe Comment do
  before(:each) do
    User.delete_all!
      KyuEntry.delete_all!
    1.times do |n|
      @user = FactoryGirl.create(:user)
        subject  = Faker::Name.name
        content  = "subject content"
        user_id  = @user.id
        @kyu= KyuEntry.create(subject: subject,
                   content: content,
                   user_id: user_id,
                   created_at: "2011-08-08 09:01:39")
    end
  end

  describe 'create_comment_activity' do
    it 'should create comment activity' do 
      comment = @kyu.comments.create(:comment => "Temporary")
      act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("comment.create")
      act.should_not be_nil        
    end
  end

  describe "update_comment_activity" do
    it "should create 'update' activity" do
      comment = @kyu.comments.create(:comment => "Temporary")
      comment.update_attributes(:comment => "Good")
      act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("comment.update")
      act.should_not be_nil
    end
  end

  describe "destroy_comment_activity" do
    it "should create 'destroy' activity" do
      comment = @kyu.comments.create(:comment => "Very good")
      comment.destroy
      act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("comment.destroy")
      act.should_not be_nil
    end
  end

  describe 'after_create' do
    it 'should run the proper callbacks' do
      comment = @kyu.comments.build(:comment => "Very good")
      comment.should_receive(:create_comment_activity)
      comment.run_callbacks(:create)
    end
  end

  describe 'after_update' do
    it 'should run the proper callbacks' do
      comment = @kyu.comments.create(:comment => "Very good")
      comment.should_receive(:update_comment_activity)
      comment.run_callbacks(:update)
    end
  end

  describe 'before_destroy' do
    it 'should run the proper callbacks' do
      comment = @kyu.comments.create(:comment => "Very good")
      comment.should_receive(:destroy_comment_activity)
      comment.run_callbacks(:destroy)
    end
  end
end