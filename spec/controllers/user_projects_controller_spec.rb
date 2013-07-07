require 'spec_helper'

describe UserProjectsController do

  let(:project) { FactoryGirl.create(:project) }
  let(:user) { FactoryGirl.create(:user) }

  let(:valid_attributes) { { user_id: user.id, project_id: project.id } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UserProjectsController. Be sure to keep this updated too.
  let(:valid_session) { { user_id: user.id } }


  describe "POST create" do
    describe "with valid params" do
      it "creates a new UserProject" do
        expect {
          post :create, {:project_id => project.id}, valid_session
        }.to change(UserProject, :count).by(1)
      end

      it "creates a UserProject for the current user" do
        post :create, {:project_id => project.id}, valid_session
        expect(UserProject.find_by(user_id: user.id)).to_not be_nil
      end

      it "redirects to the project page" do
        post :create, {:project_id => project.id}, valid_session
        expect(response).to redirect_to(Project.last)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user_project" do
      user_project = UserProject.create! valid_attributes
      expect {
        delete :destroy, {:id => user_project.to_param}, valid_session
      }.to change(UserProject, :count).by(-1)
    end

    it "redirects to the project page" do
      user_project = UserProject.create! valid_attributes
      delete :destroy, {:id => user_project.to_param}, valid_session
      expect(response).to redirect_to(Project.last)
    end
  end

end
