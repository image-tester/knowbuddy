
require 'spec_helper'

describe PostsController, type: :controller do
  describe 'actions' do
    let!(:user)       { create :user }
    let!(:user_one)   { create :user }
    let!(:post_two)   { create :post, user: user_one }
    let!(:post_one)   { create :post, subject: 'Test', content: 'demo', user: user, tag_list: "newtag" }
    let!(:file)       { File.new('spec/fixtures/docs/sample.txt')}
    let!(:post_third) { create :post, subject: 'Test content', content: 'demo content', user: user, tag_list: "tag" }
    let!(:draft)      { create :draft, user: user }

    before do
      user_one.destroy
      sign_in user
    end


    describe "GET search ", search: true do
      include SolrSpecHelper

      before(:all) do
        solr_setup
      end

      after(:all) do
        Post.remove_all_from_index!
      end

      let!(:search_key) { "Test Subject" }
      let!(:post_forth) { create :post, subject: 'Test Subject', is_draft: false }

      it "should return posts with given search key in html format" do
        xhr :get, :search, search: "Test Subject", format: :js
        expect(response).to render_template('posts/search',format: :js)
        expect(Post.search_post(search_key)).to eq [post_forth]
      end

      it "should not return posts with given search " do
        xhr :get, :search, search: "search text", format: :js
        expect(response).to render_template('posts/search', format: :js)
        expect(response.body).to be_blank
      end
    end

    describe "GET remove_tag" do
      it "should remove tag" do
        fetch_activity_type('post.update')
        get :remove_tag, tag: "Test", id: post_one.id, format: :json
        expect(response.body).to be_true
        post_one.reload
        expect(post_one.tag_list).to_not eq(["Test"])

        act = find_activity(post_one.user, "post.update")
        act.should_not be_nil
      end
    end

    describe "GET contributors_pagination" do
      it "should respond with users on page 1" do
        xhr :get, :contributors_pagination, page:"1"
        expect(assigns[:users]).to_not include(user, user_one)
      end

      it "should not respond with users of page 1" do
        xhr :get, :contributors_pagination, page:"2"
        expect(assigns[:users]).to_not include(user,user_one)
      end
    end

    describe "GET related_tag"  do
      it "should return posts tagged with given tag" do
        xhr :get, :related_tag, name: "newtag", format: :js
        expect(response).to render_template('posts/related_tag',format: :js)
        expect(assigns[:related_tags]).to eq([post_one])
      end

      it "should not include posts with other tags" do
        xhr :get, :related_tag, name: "abc", format: :js
        expect(assigns[:related_tags]).to_not eq([post_one])
        expect(response).to render_template('posts/related_tag',format: :js)
      end
    end

    describe "POST parse_content" do
      it "should return parse content" do
        @content = RedCloth.new("sample content text").to_html
        post :parse_content, id: @content, divcontent: "sample content text", format: :json
        expect(response.body).to eq(@content.to_json)
      end
    end

    describe "GET new" do
      it "creates a new post with tag" do
        expect{
          xhr :get, :new, new_post: true
        }.to_not change(Post, :count).by(1)
        expect(response).to render_template( partial: 'posts/_newentry', format: :js)
      end
    end

    describe "GET index" do
      it "displays posts of inactive users" do
        get :index
        expect(assigns[:posts]).to include(post_two)
        expect(response).to render_template('posts/index')
      end
    end

    describe "GET edit" do
      it "should response successfully to edit" do
        xhr :get, :edit, id: post_two.id
        expect(response).to render_template('posts/_editentry', format: :js)
      end
    end

    describe "GET show" do
      context "Post" do
        it "should response successfully to show" do
          get :show, id: post_two.id
          expect(response).to render_template("posts/show")
          expect(assigns[:post]).to eq(post_two)
        end

        it "should not response to show " do
          get :show, id: 1000
          expect(response).to render_template("posts/post_not_found")
        end
      end

      context "Draft" do
        it "should show draft of the user" do
          get :show, id: draft.id
          expect(response).to render_template("posts/show")
        end

        it "should not show draft of other users" do
          other_draft = create :draft
          get :show, id: other_draft.id
          expect(response).to render_template("posts/post_not_found")
        end
      end
    end

    describe "POST create" do
      context 'Valid Attributes' do
        it 'should save post to database' do
          @post = {id: '', subject: 'Swimming', content: 'freestyle', user_id: user.id}
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
          @post = {id: '', subject: '', content: 'freestyle', user_id: user.id}
          expect{
            post :create, post: @post, attachments_field: ""
          }.to_not change(Post, :count)
        end
      end

      # by AMOL

      let!(:attachment) { Attachment.create(post: file, post_id: "") }

      it 'should save post to database' do
        @post = { id: '', subject: 'New Post', content: 'New', user_id: user.id, is_draft: false }
        fetch_activity_type('post.create')
        expect{
          post :create, post: @post, attachments_field: [attachment.id], format: :js
        }.to change(Post, :count).by(1)

        new_post = Post.find_by_subject "New Post"
        expect(new_post.attachments).to eq([attachment])
        expect(response).to render_template('posts/_sidebar', format: :js)
        expect(response).to render_template('posts/_entries', format: :js)
        expect(response).to render_template('posts/_activities', format: :js)

        act = find_activity(new_post.user, "post.create")
        act.should_not be_nil
      end

      it 'Should not create post' do
        @post = {subject: '', content: 'freestyle', user_id: user.id, id: ''}
        expect{
          post :create, post: @post, attachments_field: "", format: :js
        }.to_not change(Post, :count)
        expect(response.status).to eq(406)
      end

      # END
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
        draft1 = create :draft, user_id: user.id
        draft2 = create :draft, user_id: user_one.id
        get :draft_list
        response.should be_successful
        expect(assigns[:posts]).to match_array([draft,draft1])
        expect(assigns[:posts]).to_not include(post_one)
      end
    end

    describe "DELETE destroy" do
      it "should delete post" do
        fetch_activity_type('post.destroy')
        expect {
          delete :destroy, id: post_two
        }.to change(Post, :count).by(-1)
        expect { Post.find(post_two) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { Post.with_deleted.find(post_two.id) }.not_to be_nil
        response.should redirect_to posts_path

        act = find_activity(post_two.user, "post.destroy")
        act.should_not be_nil
      end
    end

    describe "PUT update" do
      let!(:current_post) { create :post, subject: "new updated post" }
      let!(:attachment) { Attachment.create(post: file, post_id: current_post.id) }

      it "should create 'update' activity" do
        fetch_activity_type('post.update')
        put :update, post: { subject: "new updated post"}, attachments_field: [attachment.id],
          post_id: current_post.id, id: current_post.slug, format: :js

        current_post.reload
        expect(current_post.subject).to eq("new updated post")
        expect(current_post.attachments).to eq([attachment])
        expect(response).to render_template('posts/_post', format: :js)

        act = find_activity(current_post.user, "post.update")
        act.should_not be_nil
      end

      it "should render error templete" do
        expect{
          put :update, post: { subject: ""}, attachments_field: "",
            post_id: current_post.id, id: current_post.slug, format: :js
        }.to_not change{current_post.subject}
        expect(response.status).to eq(406)
      end
    end

    describe "Get post for date" do
      it "should get all post's for particular date" do
        post1 = create :post, updated_at: 1.day.ago
        post2 = create :post
        xhr :get, :post_date, post_id: post2.id,format: :js
        expect(assigns[:posts]).to include(post2)
        expect(response).to render_template('posts/post_date', format: :js)

        expect(assigns[:posts]).to_not include(post1)
      end
    end

    describe "Get post for user" do
      it "should get all post's for particular user" do
        post1 = create :post, user: user_one
        post2 = create :post, user: user
        get :user_posts, user_id: user_one.id
        expect(assigns[:posts]).to include(post1)
        expect(response).to render_template('posts/user_posts')

        expect(assigns[:posts]).to_not include(post2)
      end
    end
  end
end
