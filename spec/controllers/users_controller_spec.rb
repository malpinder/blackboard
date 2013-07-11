require 'spec_helper'

describe UsersController do

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = FactoryGirl.create(:user)
      get :show, {:nickname => user.to_param}
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      user = FactoryGirl.create(:user)
      delete :destroy, {:nickname => user.to_param}, {user_id: user.id}
      expect(User.find_by(id: user.id)).to be_nil
    end
  end

end
