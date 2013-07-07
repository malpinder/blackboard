require 'spec_helper'

describe UserProject do

  describe "#is_complete?" do
    it "returns false if it has no goal completions" do
      subject = FactoryGirl.create(:user_project)
      expect(subject).to_not be_complete
    end
    it "returns false if it has goal completions < project goals" do
      subject = FactoryGirl.create(:user_project, :in_progress)
      expect(subject).to_not be_complete
    end
    it "returns true if it has goal completions = project goals" do
      subject = FactoryGirl.create(:user_project, :complete)
      expect(subject).to be_complete
    end
  end

  describe "#percentage_completion" do
    describe "with no goals done" do
      it "returns 0" do
        expect(FactoryGirl.create(:user_project).percentage_completion).to eq 0
      end
    end
    describe "with one of three goals done" do
      it "returns 33" do
        project = FactoryGirl.create(:project, goals_count: 3)
        up = FactoryGirl.create(:user_project, :in_progress, project: project, goal_completions_count: 1)
        expect(up.percentage_completion).to eq 33
      end
    end
    describe "with two of four goals done" do
      it "returns 50" do
        project = FactoryGirl.create(:project, goals_count: 4)
        up = FactoryGirl.create(:user_project, :in_progress, project: project, goal_completions_count: 2)
        expect(up.percentage_completion).to eq 50
      end
    end
    describe "with all goals done" do
      it "returns 100" do
        expect(FactoryGirl.create(:user_project, :complete).percentage_completion).to eq 100
      end
    end
  end

end