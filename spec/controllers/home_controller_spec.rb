require 'spec_helper'

describe HomeController do
  describe "GET 'index'" do
    before do
      @user = create :user
      sign_in @user
    end

    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
end
