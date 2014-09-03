require 'spec_helper'

describe CommentsController do
  before do
    @active_user = create :user
    create_list(:comment, 2, user: @active_user)

    @inactive_user = create :user
    create_list(:comment, 2, user: @inactive_user)

    sign_in @active_user
    @inactive_user.destroy

  end

  let!(:post1) {create :post}

  describe "display comments of" do
    it "specific active user" do
      get :user_comment, id: @active_user.id
      response.should be_success
      expect(response).to render_template(:user_comment)
      expect(assigns(:comments)).to eq(@active_user.comments)
    end

    it "inactive users" do
      get :user_comment, id: @inactive_user.id
      response.should be_success
      expect(response).to render_template(:user_comment)
      expect(assigns(:comments)).to eq(@inactive_user.comments)
    end
  end

  describe 'Create Comment' do
    it 'should create new comment' do
      comment_attributes = attributes_for(:comment, user_id: @active_user.id)
      expect{
        post :create, comment: comment_attributes, post_id: post1.slug
      }.to change(Comment, :count).by(1)
      expect(response).to render_template :comment
    end
  end

  describe  'Delete Comment' do
    it 'should delete comment' do
      @comment = create :comment
      fetch_activity_type('comment.destroy')
      expect{
        delete :destroy, id: @comment.id, post_id: post1.slug
      }.to change(Comment, :count).by(-1)
      expect(response).to redirect_to post1
    end
  end

  describe 'New Comment' do
    it 'should create new comment' do
      get :new, post_id: post1.slug, format: :json
      expect(response.body).to have_content @comment.to_json
    end
  end

  describe 'Show Comment' do
    it 'should show comment' do
      @comment = create :comment
      fetch_activity_type('comment.update')
      get :show, id: @comment, post_id: post1, format: :json
      expect(response.body).to have_content @comment.to_json
    end
  end

  describe 'Update Comment' do

    let!(:comment) { create :comment }

    before { fetch_activity_type('comment.update') }

    context 'Valid Attributes' do
      it 'should Update comment' do
        comment_attributes = attributes_for(:comment, comment: "Test")
        put :update, id: comment, post_id: post1.slug, comment: comment_attributes
        comment.reload
        expect(comment.comment).to eq("Test")
        expect(response).to redirect_to comment.post
      end
    end
    context 'Invalid Attributes' do
      it 'should not update comment and rednder to edit template' do
        comment_attributes = attributes_for(:comment, comment: "")
        put :update, id: comment, post_id: post1.slug, comment: comment_attributes
        comment.reload
        expect(comment.comment).to_not eq("")
        expect(response).to render_template :edit
      end
    end
  end
end
