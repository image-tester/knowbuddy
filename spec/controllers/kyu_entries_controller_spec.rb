require 'spec_helper'

describe KyuEntriesController do
  before :each do
    User.delete_all!
    KyuEntry.delete_all!
    @user_test = User.create(name: 'user22', email: 'inactive2@kiprosh.com', password: 'inactive2',
      password_confirmation: 'inactive2')
    @user = User.create(name: 'user1', email: 'test@kiprosh.com', password: 'password',
      password_confirmation: 'password')
    @kyu = KyuEntry.create(subject: 'super bike', content: 'ducati', user_id: @user.id)
    @kyu_1 = {subject: 'Swimming', content: 'freestyle', user_id: @user.id}
    @kyu_test = KyuEntry.create(subject: 'super', content: 'test', user_id: @user_test.id)
    sign_in @user
    @user_2 = User.create(name: 'user2', email: 'inactive@kiprosh.com', password: 'inactive',
      password_confirmation: 'inactive')
    @kyu_2 = KyuEntry.create(subject: 'test2', content: 'content2', user_id: @user_2.id)
    @user_2.destroy
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
      xhr :get, :edit, id: @kyu.id
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
      @kyu = {subject: 'Swimming', content: 'freestyle', user_id: @user.id}
      post :create, kyu_entry: @kyu, attachments_field: ""
      kyu = KyuEntry.find_by_subject "Swimming"
      kyu.should_not be_nil
    end
    
    it "creates a new activity" do
      @kyu.create_activity :create, owner: @user
      act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("kyu_entry.create")
      act.should_not be_nil
    end

    it "creates a 'newTag' activity" do
      @kyu_test.tag_list = "tag"
      @kyu_test.create_activity key: 'kyu_entry.newTag',params: {"1"=> @kyu_test.tag_list}, owner: @user_test
      act = PublicActivity::Activity.find_by_owner_id(@user_test.id) && PublicActivity::Activity.find_by_key("kyu_entry.newTag")
      expect(act.parameters).not_to be_empty
      act.should_not be_nil
    end
    
  end

  describe "DELETE destroy" do
   it "should delete kyu_entry" do
     @kyu.destroy
     deleted_kyu = KyuEntry.find_by_id(@kyu.id)
     deleted_kyu.should be_nil
     deleted_kyu1 = KyuEntry.with_deleted.find_by_id(@kyu.id)
     deleted_kyu1.deleted_at.should_not be_nil
   end

   it "should create 'destroy' activity" do
      @kyu.create_activity :destroy, owner: @user
      act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("kyu_entry.destroy")
      act.should_not be_nil
      end
  end

  describe "PUT update" do
    it "should create 'update' activity" do
      @kyu.create_activity :update, owner: @user
      act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("kyu_entry.update")
      act.should_not be_nil
    end

    it "should create 'newTag' activity" do
      @kyu_test.tag_list = "tag"
      @kyu_test.create_activity key: 'kyu_entry.newTag',params: {"1"=> @kyu_test.tag_list}, owner: @user_test
      act = PublicActivity::Activity.find_by_owner_id(@user_test.id) && PublicActivity::Activity.find_by_key("kyu_entry.newTag")
      expect(act.parameters).not_to be_empty
      act.should_not be_nil
    end
  end
  describe "Get post for date" do
    it "should get all kyu's for particular date" do
      get :kyu_date, :kyu_id => @kyu.id
      response.should be_successful
    end
  end

  describe "Get post for user" do
    it "should get all kyu's for particular user" do
      get :user_kyu, user_id: @user.id
      response.should be_successful
    end
  end

  describe "search" do
    include SolrSpecHelper
    before :each do
      User.delete_all!
      KyuEntry.delete_all!
      Comment.delete_all
      solr_setup
      @user = User.create(email: 'testing@kiprosh.com', password: 'password', password_confirmation: 'password', name: 'test')
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

    it "should list kyu_entries where matching user name has commented on posts " do
      @user_1 = User.create(email: 'rspec@kiprosh.com', password: 'password', password_confirmation: 'password', name: 'xyz')
      @user_2 = User.create(email: 'rspec2@kiprosh.com', password: 'password', password_confirmation: 'password', name: 'abc')
      @kyu_2 = KyuEntry.create(subject: 'sky diving', content:'freefall', user_id: @user_2.id)
      @comment = Comment.create(comment: 'awesome', user_id: @user_1.id, kyu_entry_id: @kyu_2.id)
      KyuEntry.reindex
      results = KyuEntry.solr_search do
        keywords "xyz"
      end.results
      results.size.should == 1
      results.include?(@kyu_2).should == true
    end

    it "should search kyu_entry by content" do
      results = KyuEntry.solr_search do
        keywords "boxing"
      end.results
      results.size.should == 1
      results.include?(@kyu_1).should == true
      results.include?(@kyu).should == false
    end

    it "should search kyu_entry by username" do
      results = KyuEntry.solr_search do
        keywords "test"
      end.results
      results.size.should == 2
      results.include?(@kyu).should == true
      results.include?(@kyu_1).should == true
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