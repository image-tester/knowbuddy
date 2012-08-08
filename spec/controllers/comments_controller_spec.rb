require 'spec_helper'

describe CommentsController do
  before :each do
    User.delete_all
    KyuEntry.delete_all
    Comment.delete_all

    @kyu1 = FactoryGirl.create(:kyu_entry)
    @comment1 = FactoryGirl.create(:comment)
    @user1 = @comment1.user

    @kyu2 = FactoryGirl.create(:kyu_entry)
    @comment2 = FactoryGirl.create(:comment)
    @user2 = @comment2.user

    @comment3 = FactoryGirl.create(:comment, :user_id => @user1.id, :kyu_entry_id => @kyu2.id)
    @comment4 = FactoryGirl.create(:comment, :user_id => @user2.id, :kyu_entry_id => @kyu1.id)

    @user2.destroy
  end

  describe "display comments" do
    it "displays comments of perticular users" do
      comments = Comment.find(:all, conditions: {:user_id => @user1.id})
      comments.should_not be_nil
      comments.length == 2
    end

    it "displays comments of inactive users" do
      comments = Comment.find(:all, conditions: {:user_id => @user2.id})
      comments.should_not be_nil
      comments.length == 2
    end
  end

end

