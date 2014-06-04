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
end
