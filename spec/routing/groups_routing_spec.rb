require "spec_helper"

describe GroupsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/groups")).to route_to("groups#index")
    end

    it "routes to #show" do
      expect(get("/groups/1")).to route_to("groups#show", :id => "1")
    end

  end
end
