require "spec_helper"

describe EquipmentController do
  describe "routing" do

    it "routes to #index" do
      get("/equipment").should route_to("equipment#index")
    end

    it "routes to #new" do
      get("/equipment/new").should route_to("equipment#new")
    end

    it "routes to #show" do
      get("/equipment/1").should route_to("equipment#show", :id => "1")
    end

    it "routes to #edit" do
      get("/equipment/1/edit").should route_to("equipment#edit", :id => "1")
    end

    it "routes to #create" do
      post("/equipment").should route_to("equipment#create")
    end

    it "routes to #update" do
      put("/equipment/1").should route_to("equipment#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/equipment/1").should route_to("equipment#destroy", :id => "1")
    end

  end
end
