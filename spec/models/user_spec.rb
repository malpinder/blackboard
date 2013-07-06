require 'spec_helper'

describe User do
  describe ".find_or_create_by_auth_hash" do
    let(:auth_hash) { example_omniauth_github_response }

    let(:user) { User.find_or_create_by_auth_hash(auth_hash) }
    describe "when there is a record matching provider & uid" do
      let!(:existing_user) {FactoryGirl.create(:user, uid: "12345", provider: "github") }
      it "returns the record" do
        expect(user).to eq(existing_user)
      end
    end

    describe "when there is not a record matching provider & uid" do
      it "does not return a user with a different uid" do
        other_user = FactoryGirl.create(:user, uid: "54321", provider: "github")
        expect(user).not_to eq(other_user)
      end
      it "does not return a user with a different provider" do
        fb_user = FactoryGirl.create(:user, uid: "12345", provider: "facebook")
        expect(user).not_to eq(fb_user)
      end
      it "creates a new user record" do
        expect { user }.to change{User.count}.from(0).to(1)
      end
      it "creates the user with correct attributes" do
        expect(user).not_to be_nil
        expect(user.name).to eq(auth_hash[:info][:name])
        expect(user.github_url).to eq(auth_hash[:info][:urls]["GitHub"])
        expect(user.image_url).to eq(auth_hash[:info][:image])
      end
    end
  end

  let(:user) { FactoryGirl.build(:user, name: "Mary Allen W", nickname: "maryallenw") }

  describe "#display_name" do
    subject { user.display_name }
    it "returns the name if there is a name present" do
      expect(subject).to eq(user.name)
    end
    it "returns the nickname if name is blank" do
      user.name = ""
      expect(subject).to eq(user.nickname)
    end
  end

  describe "#to_param" do
    it "returns the nickname" do
      expect(user.to_param).to eq user.nickname
    end
  end

  describe "#has_completed?" do
    subject { FactoryGirl.create(:user) }

    it "returns false for a user with no user projects" do
      project = FactoryGirl.create(:project)
      expect(subject).to_not have_completed(project)
    end
    it "returns false for a user who has started the project" do
      project = FactoryGirl.create(:project, started_by: [subject])
      expect(subject).to_not have_completed(project)
    end
    it "returns false for a user who has not completed the project" do
      project = FactoryGirl.create(:project, worked_on_by: [subject])
      expect(subject).to_not have_completed(project)
    end
    it "returns true for a user who has completed the project" do
      project = FactoryGirl.create(:project, completed_by: [subject])
      expect(subject).to have_completed(project)
    end
  end

  describe "#working_on?" do
    subject { FactoryGirl.create(:user) }

    it "returns false for a user with no user projects" do
      project = FactoryGirl.create(:project)
      expect(subject).to_not be_working_on(project)
    end
    it "returns true for a user who has started the project" do
      project = FactoryGirl.create(:project, started_by: [subject])
      expect(subject).to be_working_on(project)
    end
    it "returns true for a user who has not completed the project" do
      project = FactoryGirl.create(:project, worked_on_by: [subject])
      expect(subject).to be_working_on(project)
    end
    it "returns false for a user who has completed the project" do
      project = FactoryGirl.create(:project, completed_by: [subject])
      expect(subject).to_not be_working_on(project)
    end
  end
end
