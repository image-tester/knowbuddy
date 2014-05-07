require 'spec_helper'

describe PostsController do
  describe 'actions' do
    before do
      @user = create :user
      @user_2 = create :user
      @post = create :post, user: @user
      @post_2 = create :post, user: @user_2
      @user_2.destroy

      sign_in @user
    end

    describe "GET index" do
      it "displays posts of inactive users" do
        get :index
        response.should be_successful
        expect(assigns[:posts]).to include(@post_2)
      end
    end

    describe "GET edit" do
      it "should response successfully to edit" do
        xhr :get, :edit, id: @post.id
        response.should be_successful
      end
    end

    describe "GET show" do
      it "should response successfully to show" do
        get :show, id: @post_2.id
        expect(assigns[:post]).to eq(@post_2)
        response.should be_successful
      end
    end

    describe "POST create" do
      it "creates a new Post" do
        @post = {subject: 'Swimming', content: 'freestyle', user_id: @user.id}
        post :create, post: @post, attachments_field: ""
        post = Post.find_by_subject "Swimming"
        post.should_not be_nil
      end
    end

    describe "DELETE destroy" do
      it "should delete post" do
        fetch_activity_type('post.destroy')
        @post.destroy
        expect { Post.find(@post) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { Post.with_deleted.find(@post.id) }.not_to be_nil
      end
    end

    describe "PUT update" do
      it "should create 'update' activity" do
        fetch_activity_type('post.update')
        @post.create_activity :update, owner: @user
        act = PublicActivity::Activity.find_by_owner_id_and_key(@user.id, "post.update")
        act.should_not be_nil
      end
    end

    describe "Get post for date" do
      it "should get all post's for particular date" do
        get :post_date, post_id: @post.id
        response.should be_successful
      end
    end

    describe "Get post for user" do
      it "should get all post's for particular user" do
        get :user_posts, user_id: @user.id
        response.should be_successful
      end
    end
  end
end
