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

end