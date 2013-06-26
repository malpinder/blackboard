require 'spec_helper'

describe UsersController do

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProjectsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = FactoryGirl.create(:user)
      get :show, {:nickname => user.to_param}, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end


end
