require 'spec_helper'

describe User do
  describe "#find_or_create_by_auth_hash" do
    let(:auth_hash) { example_omniauth_github_response }

    let(:user) { User.find_or_create_by_auth_hash(auth_hash) }
    describe "when there is a record matching provider & uid" do
      let!(:existing_user) {FactoryGirl.create(:user, uid: "12345", provider: "github") }
      it "returns the record" do
        expect(user).to eq existing_user
      end
    end

    describe "when there is not a record matching provider & uid" do
      it "does not return a user with a different uid" do
        other_user = FactoryGirl.create(:user, uid: "54321", provider: "github")
        expect(user).not_to eq other_user
      end
      it "does not return a user with a different provider" do
        fb_user = FactoryGirl.create(:user, uid: "12345", provider: "facebook")
        expect(user).not_to eq fb_user
      end
      it "creates a new user record" do
        expect { user }.to change{User.count}.from(0).to(1)
      end
      it "creates the user with correct attributes" do
        expect(user).not_to be_nil
        expect(user.name).to eq auth_hash[:info][:name]
        expect(user.github_url).to eq auth_hash[:info][:urls]["GitHub"]
        expect(user.image_url).to eq auth_hash[:info][:image]
      end
    end

  end

  describe "#display_name" do
    let(:user) { User.new(name: "Mary Allen W", nickname: "maryallenw") }
    subject { user.display_name }
    it "returns the name if there is a name present" do
      expect(subject).to eq user.name
    end
    it "returns the nickname if name is blank" do
      user.name = ""
      expect(subject).to eq user.nickname
    end
  end
end
