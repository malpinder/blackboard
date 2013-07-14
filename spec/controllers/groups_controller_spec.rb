require 'spec_helper'

describe GroupsController do

  describe "GET index" do
    it "assigns all groups as @groups" do
      group = FactoryGirl.create(:group)
      get :index, {}
      expect(assigns(:groups)).to eq([group])
    end
  end

  describe "GET show" do
    it "assigns the requested project as @project" do
      group = FactoryGirl.create(:group)
      get :show, {:id => group.to_param}
      expect(assigns(:group)).to eq(group)
    end
  end
end
