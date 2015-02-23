require 'rails_helper'

describe "Posts" do
  describe "GET /posts" do
    it "should redirect to login if user is not logged in" do
      get posts_path
      expect(response.status).to eq 302
      expect(response.status).to_not eq 200
    end
  end
end
