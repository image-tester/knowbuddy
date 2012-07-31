require 'spec_helper'

describe UsersController do
  before :each do
    User.delete_all
    @user = User.create(name: 'user1', email: 'test@kiprosh.com', password: 'password', password_conformation: 'password')
    sign_in @user
  end

  describe "Update user" do
    it "should response successfully to update" do
      @user.update_attributes(name: 'test')
      put :update, id: @user, format: 'json'
      response.should be_successful
    end
  end
end
