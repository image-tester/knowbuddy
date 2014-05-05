require 'spec_helper'

describe UsersController do
  before do
    @user = create :user
    sign_in @user
  end

  describe "Update user" do
    it "should successfully update user name" do
      put :update, id: @user, user: {name: Faker::Name.name, password: "",
        password_confirmation: "", current_password: @user.password },
          format: 'json'
      response.should be_successful
    end

    it "should successfully change password" do
      put :update, id: @user, user: {name: Faker::Name.name,
        password: "password123", password_confirmation: "password123",
          current_password: @user.password }, format: 'json'
      response.should be_successful
    end

    it "should not update password incase password isnt confirmed properly" do
      put :update, id: @user, user: {name: Faker::Name.name,
        password: "password123", password_confirmation: "password",
          current_password: @user.password }, format: 'json'
      response.should_not be_successful
    end

    it "should not update user name incase password is not correct" do
      put :update, id: @user, user: {name: Faker::Name.name,
        password: "", password_confirmation: "",
          current_password: 'newuser' }, format: 'json'
      response.should_not be_successful
    end
  end
end
