require "spec_helper"

describe UnitsController do
  describe "routing" do

    it "routes to #index" do
      get("/units").should route_to("units#index")
    end

    it "routes to #new" do
      get("/units/new").should route_to("units#new")
    end

    it "routes to #show" do
      get("/units/1").should route_to("units#show", :id => "1")
    end

    it "routes to #edit" do
      get("/units/1/edit").should route_to("units#edit", :id => "1")
    end

    it "routes to #create" do
      post("/units").should route_to("units#create")
    end

    it "routes to #update" do
      put("/units/1").should route_to("units#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/units/1").should route_to("units#destroy", :id => "1")
    end

  end
end
