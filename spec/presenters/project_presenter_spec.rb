require 'spec_helper'

describe ProjectPresenter do
  let(:project) { FactoryGirl.build(:project) }

  describe ".new" do
    it "requires a project argument" do
      expect{ ProjectPresenter.new }.to raise_error(ArgumentError)
      expect{ ProjectPresenter.new(project) }.to_not raise_error(ArgumentError)
    end
    it "has an optional user argument" do
      expect{ ProjectPresenter.new(project, User.new) }.to_not raise_error(ArgumentError)
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

end