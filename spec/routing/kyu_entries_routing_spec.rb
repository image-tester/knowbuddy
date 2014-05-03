require "spec_helper"

describe KyuEntriesController do
  describe "routing" do

    it "routes to #index" do
      get("/kyu_entries").should route_to("kyu_entries#index")
    end

    it "routes to #new" do
      get("/kyu_entries/new").should route_to("kyu_entries#new")
    end

    it "routes to #show" do
      get("/kyu_entries/1").should route_to("kyu_entries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/kyu_entries/1/edit").should route_to("kyu_entries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/kyu_entries").should route_to("kyu_entries#create")
    end

    it "routes to #update" do
      put("/kyu_entries/1").should route_to("kyu_entries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/kyu_entries/1").should route_to("kyu_entries#destroy", :id => "1")
    end

  end
end
