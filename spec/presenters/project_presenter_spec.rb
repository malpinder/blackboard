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

  describe "#can_complete_goals?" do
    subject { ProjectPresenter.new(project) }
    it "is true if there is a current_user_project" do
      subject.stub(:current_user_project).and_return(UserProject.new)
      expect(subject.can_complete_goals?).to be_true
    end
    it "is false if there is no current_user_project" do
      subject.stub(:current_user_project).and_return(nil)
      expect(subject.can_complete_goals?).to be_false
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