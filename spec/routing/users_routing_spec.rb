require "spec_helper"

describe UsersController do
  describe "routing" do

    it "routes to #show" do
      expect(get("/users/idar")).to route_to("users#show", :nickname => "idar")
    end

  end
end
