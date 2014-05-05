require 'spec_helper'

describe CommentsController do
  before do
    @kyu = create :kyu_entry
    @comment_active = create :comment
    @user_active = @comment_active.user

    @kyu_new = create :kyu_entry
    @comment_inactive = create :comment
    @user_inactive = @comment_inactive.user

    @comment_act = create(:comment, user: @user_active, kyu_entry: @kyu_new)
    @comment_inact = create(:comment, user: @user_inactive, kyu_entry: @kyu)

    @comment_del = create(:comment, user: @user_active, kyu_entry: @kyu_new)
    @user_inactive.destroy
  end

  describe "display comments" do
    it "displays comments of perticular users" do
      comments = Comment.find(:all, conditions: {:user_id => @user_active.id})
      comments.should_not be_nil
      comments.length == 2
    end

    it "displays comments of inactive users" do
      comments = Comment.find(:all, conditions: {:user_id => @user_inactive.id})
      comments.should_not be_nil
      comments.length == 2
    end
  end
end
