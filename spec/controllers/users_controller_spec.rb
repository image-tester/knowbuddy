require 'rails_helper'

describe UsersController do
  let!(:user) {create :user}

  before(:each) do
    sign_in user
  end

  describe "Update user" do
    let!(:new_password) { "password123" }
    let!(:params) {{ password: 'password123', password_confirmation: 'password',
        current_password: 'passwod'}}

    it "should successfully update user name" do
      put :update, id: user, user: {name: "test_name"}, format: 'json'
      expect(response).to be_successful

      user.reload
      expect(user.name).to eq("test_name")
    end

    it "should not update user name with blank" do
      expect{
        put :update, id: user, user: {name: ""}, format: 'json'
       }.to_not change(user, :name)

      expect(response.status).to eq(422)
    end

    it "should successfully change password" do
      put :update, id: user, user: { current_password: "password",
        password: new_password, password_confirmation: new_password,  },
          format: 'json'
      expect(response).to be_successful
    end

    it "should not update password if password is not confirmed properly" do
        expect{
          put :update, id: user, user: params
        }.to_not change(user, :encrypted_password)

        expect(response).to render_template('edit',format: :html)
    end

  end
end
