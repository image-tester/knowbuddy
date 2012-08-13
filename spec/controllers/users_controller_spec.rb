require 'spec_helper'

describe UsersController do
  before :each do
    User.delete_all
    @user = User.create(name: 'user1', email: 'test@kiprosh.com', password: 'password', password_conformation: 'password')
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
  end
end
