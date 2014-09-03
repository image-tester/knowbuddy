
require 'spec_helper'

describe PostsController do
  describe 'actions' do
    let!(:user)   { create :user }
    let!(:user_one) { create :user }
    let!(:post_two) { create :post, user: user_one }
    let!(:post_one) { create :post, subject: 'Test', content: 'demo', user: user, tag_list: "newtag" }
    let!(:file) { File.new('spec/fixtures/docs/sample.txt')}
    let!(:post_third) { create :post, subject: 'Test content', content: 'demo content', user: user, tag_list: "tag" }

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
      let!(:post_forth) { create :post, subject: 'Test Subject' }

      it "should return posts with given search key in html format" do
        get :search, search: "Test Subject"
        expect(response).to render_template('posts/search',format: :html)
        expect(Post.search_post(search_key)).to eq [post_forth]
      end

      it "should return posts with given search key in json format" do
        get :search, search: "Test Subject", format: :json
        response.body.should have_content post_forth.to_json
        expect(Post.search_post(search_key)).to eq [post_forth]
      end

      it "should return posts with given search key in js format" do
        xhr :get, :search, search: "Test Subject"
        expect(response).to render_template('render_contributors_pagination', format: :js)
        expect(Post.search_post(search_key)).to eq [post_forth]
      end

      it "should not return posts with given search " do
        get :search, search: "search text"
        expect(response).to render_template('posts/search', format: :html)
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

    describe "GET render_contributors_pagination" do
      it "should respond with javascript" do
        xhr :get, :render_contributors_pagination
        response.should be_success
      end
    end

    describe "GET related_tag"  do
      it "should return posts tagged with given tag" do
        get :related_tag, name: "newtag"
        expect(response).to render_template('posts/related_tag',format: :html)
        expect(assigns[:related_tags]).to eq([post_one])
      end

      it "should not include posts with other tags" do
        get :related_tag, name: "abc"
        expect(assigns[:related_tags]).to_not eq([post_one])
        expect(response).to render_template('posts/related_tag',format: :html)
      end
    end

    describe "GET load_activities" do
      it 'should hide View More link if activities are less than ACTIVITIES_PER_PAGE' do
        create_list :activity, 30
        xhr :get, :index, format: :js, page_3: "2"
        expect(assigns[:posts]).to include(post_two)
        expect(JSON.parse(response.body)["hide_link"]).to be_true
        expect(response).to render_template(partial: 'posts/_activities', format: :js)
      end

      it 'should not hide View More link if activities are more than ACTIVITIES_PER_PAGE' do
        create_list :activity, 40
        xhr :get, :index, format: :js, page_3: "2"
        expect(assigns[:posts]).to include(post_two)
        expect(JSON.parse(response.body)["hide_link"]).to be_false
        expect(response).to render_template(partial: 'posts/_activities', format: :js)
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

      it "respond successfully for js request " do
        xhr :get, :index
        expect(assigns[:posts]).to include(post_two)
        expect(response).to render_template('posts/render_contributors_pagination', format: :js)
      end
    end

    describe "GET edit" do
      it "should response successfully to edit" do
        xhr :get, :edit, id: post_two.id
        expect(response).to render_template('posts/_editentry', format: :js)
      end
    end

    describe "GET show" do
      it "should response successfully to show" do
        get :show, id: post_two.id
        expect(response).to render_template('posts/show')
        expect(assigns[:post]).to eq(post_two)
      end

      it "should not response to show " do
        get :show, id: 1000
        expect(response).to render_template('posts/post_not_found')
      end
    end

    describe "POST create" do
      let!(:attachment) { Attachment.create(post: file, post_id: "") }

      it 'should save post to database' do
        @post = { subject: 'New Post', content: 'New', user_id: user.id }
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
        @post = {subject: '', content: 'freestyle', user_id: user.id}
        expect{
          post :create, post: @post, attachments_field: "", format: :js
        }.to_not change(Post, :count)
        expect(response.status).to eq(406)
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

      it "shold render error templete" do
        expect{
          put :update, post: { subject: ""}, attachments_field: "",
            post_id: current_post.id, id: current_post.slug, format: :js
        }.to_not change{current_post.subject}
        expect(response.status).to eq(406)
      end
    end

    describe "Get post for date" do
      it "should get all post's for particular date" do
        post1 = create :post, created_at: 1.day.ago
        post2 = create :post
        get :post_date, post_id: post2.id
        expect(assigns[:posts]).to include(post2)
        expect(response).to render_template('posts/post_date', format: :html)

        expect(assigns[:posts]).to_not include(post1)
      end
    end

    describe "Get post for user" do
      it "should get all post's for particular user" do
        post1 = create :post, user: user_one
        post2 = create :post, user: user
        get :user_posts, user_id: user_one.id
        expect(assigns[:posts]).to include(post1)
        expect(response).to render_template('posts/user_posts', format: :html)

        expect(assigns[:posts]).to_not include(post2)
      end
    end
  end
end
