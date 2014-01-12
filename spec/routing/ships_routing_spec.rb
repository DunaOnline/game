require "spec_helper"

describe ShipsController do
  describe "routing" do

    it "routes to #index" do
      get("/ships").should route_to("ships#index")
    end

    it "routes to #new" do
      get("/ships/new").should route_to("ships#new")
    end

    it "routes to #show" do
      get("/ships/1").should route_to("ships#show", :id => "1")
    end

    it "routes to #edit" do
      get("/ships/1/edit").should route_to("ships#edit", :id => "1")
    end

    it "routes to #create" do
      post("/ships").should route_to("ships#create")
    end

    it "routes to #update" do
      put("/ships/1").should route_to("ships#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/ships/1").should route_to("ships#destroy", :id => "1")
    end

  end
end
