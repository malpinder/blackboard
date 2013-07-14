require 'spec_helper'

describe ProjectPresenter do
  let(:project) { FactoryGirl.build(:project) }

  describe ".new" do
    it "requires a project argument" do
      expect{ ProjectPresenter.new }.to raise_error(ArgumentError)
      expect{ ProjectPresenter.new(project) }.to_not raise_error
    end
    it "has an optional user argument" do
      expect{ ProjectPresenter.new(project, User.new) }.to_not raise_error
    end
  end

  describe "#status" do
    let(:user) { FactoryGirl.create(:user) }
    it "returns :needs_login for a plain project" do
      presenter = ProjectPresenter.new(project)

      expect(presenter.status).to eq :needs_login
    end
    it "returns :ready with a user who hasn't started the project" do
      project = FactoryGirl.create(:project)
      presenter = ProjectPresenter.new(project, user)

      expect(presenter.status).to eq :ready
    end
    it "returns :in_progress with a user who is working on the project" do
      project = FactoryGirl.create(:project, worked_on_by: [user])
      presenter = ProjectPresenter.new(project, user)

      expect(presenter.status).to eq :in_progress
    end
    it "returns :finished with a user who has finished the project" do
      project = FactoryGirl.create(:project, completed_by: [user])

      presenter = ProjectPresenter.new(project, user)

      expect(presenter.status).to eq :finished
    end
  end

  describe "#worked_on_user_projects" do
    let(:project) { FactoryGirl.create(:project) }
    subject { ProjectPresenter.new(project).worked_on_user_projects }
    it "returns user projects with no progress" do
      user_project = FactoryGirl.create(:user_project, project: project)
      expect(subject).to include user_project
    end
    it "returns user projects with some progress" do
      user_project = FactoryGirl.create(:user_project, :in_progress, project: project)
      expect(subject).to include user_project
    end
    it "does not return user projects that are complete" do
      user_project = FactoryGirl.create(:user_project, :complete, project: project)
      expect(subject).to_not include user_project
    end
    it "does not return user_projects for the user" do
      user_project = FactoryGirl.create(:user_project, :in_progress, project: project)
      user = user_project.user
      expect(ProjectPresenter.new(project, user).worked_on_user_projects).to_not include user_project
    end
  end

  describe "#completed_user_projects" do
    let(:project) { FactoryGirl.create(:project) }
    subject { ProjectPresenter.new(project).completed_user_projects }
    it "doesn not return user projects with no progress" do
      user_project = FactoryGirl.create(:user_project, project: project)
      expect(subject).to_not include user_project
    end
    it "does not return user projects with some progress" do
      user_project = FactoryGirl.create(:user_project, :in_progress, project: project)
      expect(subject).to_not include user_project
    end
    it "returns user projects that are complete" do
      user_project = FactoryGirl.create(:user_project, :complete, project: project)
      expect(subject).to include user_project
    end

    it "does not return user_projects for the user" do
      user_project = FactoryGirl.create(:user_project, :complete, project: project)
      user = user_project.user
      expect(ProjectPresenter.new(project, user).completed_user_projects).to_not include user_project
    end
  end
end