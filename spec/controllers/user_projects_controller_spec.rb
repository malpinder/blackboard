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
      it "creates a new UserProject for the current user" do
        expect {
          post :create, {:project_id => project.id}, valid_session
        }.to change(UserProject, :count).by(1)
      end

      it "redirects to the project page" do
        post :create, {:project_id => project.id}, valid_session
        response.should redirect_to(Project.last)
      end
    end
  end
end
