require 'spec_helper'

describe UserProject do

  describe "validations" do
    describe "github repo url" do
      let (:user_project) { FactoryGirl.build(:user_project) }
      let (:valid_host) { "https://www.github.com/" }
      let (:nickname) { user_project.user.nickname }
      it "can be blank" do
        user_project.github_repo_url = nil
        expect(user_project).to be_valid
      end

      it "cannot be an invalid url" do
        user_project.github_repo_url = "Foo"
        expect(user_project).to_not be_valid
      end

      it "cannot be a non-github url" do
        user_project.github_repo_url = "http://www.example.com"
        expect(user_project).to_not be_valid
      end

      it "cannot be a github url with non-alpha-numeric characters for the repo name" do
        user_project.github_repo_url = "#{valid_host}#{nickname}/#4XX0R"
        expect(user_project).to_not be_valid
      end

      it "cannot be a github url with exploitative code" do
        user_project.github_repo_url = "#{valid_host}#{nickname}/bar#4X<script>alert('Injected!');</script>X0R"
        expect(user_project).to_not be_valid
      end

      it "cannot be a valid github repo url for a diffent user" do
        user_project.github_repo_url = "#{valid_host}GeorgeE/reponame"
        expect(user_project).to_not be_valid
      end

      it "can be a valid github repo url for the correct user" do
        user_project.github_repo_url = "#{valid_host}#{nickname}/bar"
        expect(user_project).to be_valid
      end

      it "can be a valid github repo url for the correct user EVEN IN ALL CAPS" do
        user_project.github_repo_url = "#{valid_host}#{nickname.upcase}/bar"
        expect(user_project).to be_valid
      end
    end
  end

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