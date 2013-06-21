require "spec_helper"

describe UserProjectsController do
  describe "routing" do

    it "routes to #create" do
      post("/user_projects").should route_to("user_projects#create")
    end

    it "routes to #destroy" do
      delete("/user_projects/1").should route_to("user_projects#destroy", :id => "1")
    end

  end
end
