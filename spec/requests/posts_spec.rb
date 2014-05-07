require 'spec_helper'

describe "Posts" do
  describe "GET /posts" do
    it "should redirect to login if user is not logged in" do
      get posts_path
      response.status.should be(302)
      response.status.should_not be(200)
    end
  end
end
