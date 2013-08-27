require 'spec_helper'

describe "KyuEntries" do
  describe "GET /kyu_entries" do

    it "should redirect to login if user is not logged in" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get kyu_entries_path
      response.status.should be(302)
      response.status.should_not be(200)
    end
  end
end