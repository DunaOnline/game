require "spec_helper"

describe OrbitsController do
  describe "routing" do

    it "routes to #index" do
      get("/orbits").should route_to("orbits#index")
    end

    it "routes to #new" do
      get("/orbits/new").should route_to("orbits#new")
    end

    it "routes to #show" do
      get("/orbits/1").should route_to("orbits#show", :id => "1")
    end

    it "routes to #edit" do
      get("/orbits/1/edit").should route_to("orbits#edit", :id => "1")
    end

    it "routes to #create" do
      post("/orbits").should route_to("orbits#create")
    end

    it "routes to #update" do
      put("/orbits/1").should route_to("orbits#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/orbits/1").should route_to("orbits#destroy", :id => "1")
    end

  end
end
