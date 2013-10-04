require 'spec_helper'

describe CommentsController do
  before :each do
    User.delete_all
    KyuEntry.delete_all
    Comment.delete_all

    @kyu = FactoryGirl.create(:kyu_entry)
    @comment_active = FactoryGirl.create(:comment)
    @user_active = @comment_active.user

    @kyu_new = FactoryGirl.create(:kyu_entry)
    @comment_inactive = FactoryGirl.create(:comment)
    @user_inactive = @comment_inactive.user

    @comment_act = FactoryGirl.create(:comment, :user_id => @user_active.id, :kyu_entry_id => @kyu_new.id)
    @comment_inact = FactoryGirl.create(:comment, :user_id => @user_inactive.id, :kyu_entry_id => @kyu.id)

    @comment_del = Comment.create(comment: 'ducati', user_id: @user_active.id, kyu_entry_id: @kyu_new.id)
    KyuEntry.reindex
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

  describe "DELETE destroy" do
    it "should delete a comment" do
      @comment_del.destroy
      deleted_comment = Comment.find_by_id(@comment_del.id)
      deleted_comment.should be_nil
    end
  end

  describe "index search" do
    include SolrSpecHelper
    before :each do
      User.delete_all!
      KyuEntry.delete_all!
      Comment.delete_all
      solr_setup
      @user_index = User.create(email: 'rspec@kiprosh.com', password: 'password', password_confirmation: 'password', name: 'xyz')
      @kyu_index = KyuEntry.create(subject: 'sky diving', content:'freefall', user_id: @user_index.id)
      @comment_index = Comment.create(comment: 'awesome', user_id: @user_index.id, kyu_entry_id: @kyu_index.id)
      sign_in @user_index
    end

    it "add the index to solr_search after comment insert" do
      KyuEntry.reindex
      results = KyuEntry.solr_search do
        keywords "awesome"
      end.results
      results.size.should == 1
      results.include?(@kyu_index).should == true
    end

    it "remove the index from solr_search afer comment deletion" do
      @comment_index.destroy
      KyuEntry.reindex
      results = KyuEntry.solr_search do
        keywords "awesome"
      end.results
      results.size.should == 0
      results.include?(@kyu_index).should == false
    end
  end
end

