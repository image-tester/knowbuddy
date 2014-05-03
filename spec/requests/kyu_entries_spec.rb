require 'spec_helper'

describe "KyuEntries" do
  describe "GET /kyu_entries" do
    it "should redirect to login if user is not logged in" do
      get kyu_entries_path
      response.status.should be(302)
      response.status.should_not be(200)
    end
  end
end