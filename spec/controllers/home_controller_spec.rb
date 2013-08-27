require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    before :each do
      @user = User.create(email: 'rspec@kiprosh.com', password: 'password',
        password_confirmation: 'password', name: 'xyz')
      sign_in @user
    end

    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
end
