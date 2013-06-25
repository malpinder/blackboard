require "spec_helper"

describe UserProjectsController do
  describe "routing" do

    it "routes to #create" do
      expect(post("/user_projects")).to route_to("user_projects#create")
    end

    it "routes to #destroy" do
      expect(delete("/user_projects/1")).to route_to("user_projects#destroy", :id => "1")
    end

  end
end
