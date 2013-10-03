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

    @comment5 = Comment.create(comment: 'ducati', user_id: @user1.id, kyu_entry_id: @kyu2.id)
    KyuEntry.reindex
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

  describe "DELETE destroy" do
    it "should delete a comment" do
      @comment5.destroy
      deleted_comment = Comment.find_by_id(@comment5.id)
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
      @comment_ind.destroy
      KyuEntry.reindex
      results = KyuEntry.solr_search do
        keywords "awesome"
      end.results
      results.size.should == 0
      results.include?(@kyu_index).should == false
    end
  end
end

