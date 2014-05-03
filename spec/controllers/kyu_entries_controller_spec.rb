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
end
