require 'spec_helper'

describe KyuEntriesController do
  before :each do
    User.delete_all
    KyuEntry.delete_all
    @user = User.create(name: 'user1', email: 'test@kiprosh.com', password: 'password', password_conformation: 'password')
    @kyu = KyuEntry.create(subject: 'super bike', content: 'ducati', user_id: @user.id)
    @kyu_1 = {subject: 'Swimming', content: 'freestyle', user_id: @user.id}
    sign_in @user
    @user_2 = User.create(name: 'user2', email: 'inactive@kiprosh.com', password: 'inactive',
password_conformation: 'inactive')
    @kyu_2 = KyuEntry.create(subject: 'test2', content: 'content2', user_id: @user_2.id)
    @user_2.deleted_at = Time.now
    @user_2.save
  end

  describe "GET index" do
    it "displays kyu_entries of inactive users" do
      get :index
      kyu2 = KyuEntry.find_by_subject "test2"
      kyu2.should_not be_nil
    end
  end

  describe "GET edit" do
    it "should response successfully to edit" do
      get :edit, id: @kyu.id
      response.should be_successful
    end
  end

  describe "GET show" do
    it "should response successfully to show" do
      get :show, id: @kyu_2.id
      response.should be_successful
    end
  end

  describe "POST create" do
    it "creates a new KyuEntry" do
      post :create, kyu_entry: @kyu_1
      kyu = KyuEntry.find_by_subject "Swimming"
      kyu.should_not be_nil
    end
  end

  describe "DELETE destroy" do
   it "should delete kyu_entry" do
     delete :destroy, id: @kyu.id, format: "json"
     response.should be_successful
     @deleted_kyu = KyuEntry.find_by_id(@kyu.id)
     @deleted_kyu.should be_nil
   end
  end

  describe "Get post for date" do
    it "should get all kyu's for particular date" do
      get :kyu_date, :id => @kyu.id
      response.should be_successful
    end
  end

  describe "Get post for user" do
    it "should get all kyu's for particular user" do
      get :user_kyu, :id => @user.id
      response.should be_successful
    end
  end

  describe "search" do
    include SolrSpecHelper
    before :each do
      User.delete_all
      KyuEntry.delete_all
      Comment.delete_all
      solr_setup
      @user = User.create(email: 'test@kiprosh.com', password: 'password', password_conformation: 'password', name: 'test')
      @kyu = KyuEntry.create(subject: 'sky diving', content:'freefall', user_id: @user.id)
      @kyu_1 = KyuEntry.create(subject: 'mixed martial arts', content: 'boxing', user_id: @user.id)
      KyuEntry.reindex
      sign_in @user
    end

    it "should search kyu_entry by subject" do
      results = KyuEntry.solr_search do
        keywords "martial"
      end.results
      results.size.should == 1
      results.include?(@kyu_1).should == true
      results.include?(@kyu).should == false
    end

    it "should search kyu_entry by content" do
      results = KyuEntry.solr_search do
        keywords "boxing"
      end.results
      results.size.should == 1
      results.include?(@kyu_1).should == true
      results.include?(@kyu).should == false
    end

    it "should search kyu_entry by comments" do
      @comment = Comment.create(comment: 'awesome', user_id: @user.id, kyu_entry_id: @kyu.id)
      @comment_1 = Comment.create(comment: 'great', user_id: @user.id, kyu_entry_id: @kyu_1.id)
      KyuEntry.reindex
      results = KyuEntry.solr_search do
        keywords "awesome"
      end.results
      results.size.should == 1
      results.include?(@kyu).should == true
      results.include?(@kyu_1).should == false
    end
  end
end
