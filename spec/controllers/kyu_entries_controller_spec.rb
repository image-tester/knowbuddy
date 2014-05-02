require 'spec_helper'

describe KyuEntriesController do
  describe 'actions' do
    before do
      @user = create :user
      @user_2 = create :user
      @kyu = create :kyu_entry, user: @user
      @kyu_2 = create :kyu_entry, user: @user_2
      @user_2.destroy

      sign_in @user
    end

    describe "GET index" do
      it "displays kyu_entries of inactive users" do
        get :index
        response.should be_successful
        expect(assigns[:kyu_entries]).to include(@kyu_2)
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
        expect(assigns[:kyu_entry]).to eq(@kyu_2)
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
    end

    describe "DELETE destroy" do
      it "should delete kyu_entry" do
        fetch_activity_type('kyu_entry.destroy')
        @kyu.destroy
        expect { KyuEntry.find(@kyu) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { KyuEntry.with_deleted.find(@kyu.id) }.not_to be_nil
      end
    end

    describe "PUT update" do
      it "should create 'update' activity" do
        fetch_activity_type('kyu_entry.update')
        @kyu.create_activity :update, owner: @user
        act = PublicActivity::Activity.find_by_owner_id_and_key(@user.id, "kyu_entry.update")
        act.should_not be_nil
      end
    end

    describe "Get post for date" do
      it "should get all kyu's for particular date" do
        get :kyu_date, kyu_id: @kyu.id
        response.should be_successful
      end
    end

    describe "Get post for user" do
      it "should get all kyu's for particular user" do
        get :user_kyu, user_id: @user.id
        response.should be_successful
      end
    end
  end

  describe "search" do
    include SolrSpecHelper
    before do
      solr_setup
      @user = create :user, name: 'test'
      @kyu = create :kyu_entry, user: @user
      @kyu_1 = create :kyu_entry, subject: 'mixed martial arts', content: 'boxing', user: @user
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
      @user_1 = create :user, name: 'xyz'
      @user_2 = create :user, name: 'abc'
      @kyu_2 = create :kyu_entry, user: @user_2
      @comment = create :comment, user: @user_1, kyu_entry: @kyu_2
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
      @comment = create(:comment, comment: 'awesome', user: @user, kyu_entry: @kyu)
      @comment_1 = create(:comment, comment: 'great', user: @user, kyu_entry: @kyu_1)
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