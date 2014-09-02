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
      context 'Valid Attributes' do
        it 'should save post to database' do
          @post = {id: '', subject: 'Swimming', content: 'freestyle', user_id: @user.id}
          expect{
            post :create, post: @post, attachments_field: ""
          }.to change(Post, :count).by(1)

          post = Post.find_by_subject "Swimming"
          post.should_not be_nil
        end

        it 'should update the created draft and make it post' do
          draft = create :draft
          fetch_activity_type('post.update')
          expect{
            post :create, post: draft.attributes, attachments_field: ""
          }.to_not change(Post, :count)
          expect(Post.find(draft.id)[:is_draft]).to eq false
          expect(Post.find(draft.id).activities).not_to be_nil
        end
      end

      context 'Invalid Attributes' do
        it 'Should not create post' do
          @post = {id: '', subject: '', content: 'freestyle', user_id: @user.id}
          expect{
            post :create, post: @post, attachments_field: ""
          }.to_not change(Post, :count)
        end
      end
    end

    describe 'POST draft' do
      it 'should create new draft' do
        draft = attributes_for(:draft,id: '', subject: 'example')
        expect{
          post :draft, post: draft, attachments_field: ""
        }.to change(Post, :count).by(1)
        expect(Post.find_by_subject('example')[:is_draft]).to eq true
        expect(Post.find_by_subject('example').activities).to eq []
      end

      it 'should update the existing draft if draft is present' do
        draft = create :draft
        expect{
          post :draft, post: draft.attributes, attachments_field: ""
        }.to_not change(Post, :count)
        expect(Post.find(draft.id)[:is_draft]).to eq true
        expect(Post.find(draft.id).activities).to eq []
      end
    end

    describe 'Get draft_list' do
      it 'should return entire draft list for the user' do
        draft1 = create :draft, user_id: @user.id
        draft2 = create :draft, user_id: @user_2.id
        get :draft_list
        response.should be_successful
        expect(assigns[:posts]).to eq([draft1])
        expect(assigns[:posts]).to_not include(@post)
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
